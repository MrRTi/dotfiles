-- Statusline content for mini.statusline.
--
-- NOTE: the statusline redraws on every cursor move, so computing its segments
-- inline made each redraw cost O(#diagnostics) and re-walk the LSP client list.
-- Both segments are cached per buffer and invalidated by the events that can
-- actually change them; the cache fills lazily on first read afterwards. Lazy
-- fill (rather than rendering eagerly in the autocmd) also sidesteps LspDetach,
-- which fires while the detaching client is still listed by get_clients().

local M = {}

local diag_cache = {}
local lsp_cache = {}

-- Indexed by vim.diagnostic.severity: ERROR, WARN, INFO, HINT.
local diag_labels = {
	{ "E", "DiagnosticError" },
	{ "W", "DiagnosticWarn" },
	{ "I", "DiagnosticInfo" },
	{ "H", "DiagnosticHint" },
}

local function render_diagnostics(bufnr)
	local counts = vim.diagnostic.count(bufnr)
	local parts = {}
	for severity, label in ipairs(diag_labels) do
		local n = counts[severity] or 0
		if n > 0 then
			table.insert(parts, string.format("%%#%s#%s:%d", label[2], label[1], n))
		end
	end
	return #parts > 0 and (" " .. table.concat(parts, " ") .. " %#MiniStatuslineDevinfo#") or ""
end

-- LSP status -----------------------------------------------------------
--
-- vim.lsp.get_clients() only lists *attached* clients, so a server that's
-- still initializing (or one that will never attach -- missing binary, no
-- root marker) rendered no LSP segment at all. Track expected-vs-attached
-- per buffer instead, one of four states per server name, each rendered as
-- "name" + glyph (name alone for ready would be ambiguous with "hasn't been
-- checked yet"):
--   starting    -- name↻  -- FileType fired, server configured for this ft, not attached yet
--   loading     -- name↻  -- attached, hasn't reported a $/progress "end" yet (pre-ready
--                            only -- progress after reaching ready doesn't downgrade it,
--                            since servers keep reporting progress for routine
--                            background work, not just the initial startup scan)
--   ready       -- name✓  -- attached and has reached ready at least once
--   unavailable -- name✗  -- still not attached STARTUP_TIMEOUT_MS after FileType, or
--                            detached (also covers a client that crashed before attaching)
--
-- ft_to_servers maps filetype -> expected server names, read off each
-- enabled server's own `filetypes` (via vim.lsp.config, which resolves
-- lazily off nvim-lspconfig's lsp/*.lua). Built lazily on first use rather
-- than eagerly in M.setup(): setup() runs during mini.statusline's own
-- (eager) config callback, which is too early to guarantee nvim-lspconfig
-- is already on the runtimepath -- confirmed flaky in testing, where the
-- same startup sequence resolved every server's filetypes on one run and
-- came back empty on the next. FileType only ever fires once init.lua has
-- finished sourcing, so building here instead is race-free.
local STARTUP_TIMEOUT_MS = 4000

local enabled_servers = {}
local ft_to_servers = nil
local buf_state = {} -- bufnr -> { [server name] = state }
local buf_timers = {} -- bufnr -> { [server name] = uv_timer }

local function get_ft_to_servers()
	if ft_to_servers then
		return ft_to_servers
	end
	local map = {}
	for _, name in ipairs(enabled_servers) do
		local ok, cfg = pcall(function()
			return vim.lsp.config[name]
		end)
		local filetypes = ok and cfg and cfg.filetypes
		if filetypes then
			for _, ft in ipairs(filetypes) do
				map[ft] = map[ft] or {}
				table.insert(map[ft], name)
			end
		end
	end
	ft_to_servers = map
	return map
end

local function clear_timer(bufnr, name)
	local timers = buf_timers[bufnr]
	local timer = timers and timers[name]
	if timer then
		timer:stop()
		if not timer:is_closing() then
			timer:close()
		end
		timers[name] = nil
	end
end

local function clear_buf(bufnr)
	diag_cache[bufnr] = nil
	lsp_cache[bufnr] = nil
	buf_state[bufnr] = nil
	local timers = buf_timers[bufnr]
	if timers then
		for name in pairs(timers) do
			clear_timer(bufnr, name)
		end
		buf_timers[bufnr] = nil
	end
end

-- Returns one mini.statusline group per expected server, so each can carry
-- its own highlight through combine_groups's own %#hl# wrapping. Earlier
-- version built one string with %#hl# codes embedded inside it, nested
-- inside another group's strings={} -- that broke rendering (confirmed:
-- the computed string was complete per nvim_eval_statusline, but the actual
-- screen cut off mid-segment). Separate top-level groups is the pattern
-- mode/git/filename already use safely; this avoids the nesting entirely.
local function render_lsp_groups(bufnr)
	local expected = get_ft_to_servers()[vim.bo[bufnr].filetype]
	local groups = {}
	if not expected then
		return groups
	end
	local state = buf_state[bufnr] or {}
	for _, name in ipairs(expected) do
		local s = state[name] or "starting"
		if s == "ready" then
			table.insert(groups, { hl = "MiniStatuslineDevinfo", strings = { name .. "\u{2713}" } })
		elseif s == "unavailable" then
			table.insert(groups, { hl = "DiagnosticError", strings = { name .. "\u{2717}" } })
		else -- starting / loading
			table.insert(groups, { hl = "Comment", strings = { name .. "\u{21bb}" } })
		end
	end
	return groups
end

local function cached(cache, render, bufnr)
	local value = cache[bufnr]
	if value == nil then
		value = render(bufnr)
		cache[bufnr] = value
	end
	return value
end

function M.setup(opts)
	enabled_servers = opts.servers

	local group = vim.api.nvim_create_augroup("Statusline", { clear = true })

	vim.api.nvim_create_autocmd("DiagnosticChanged", {
		group = group,
		callback = function(ev)
			diag_cache[ev.buf] = nil
		end,
	})

	-- Seeds "starting" for every server this filetype expects, and arms a
	-- timeout that flips any still-unattached one to "unavailable".
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(ev)
			local expected = get_ft_to_servers()[ev.match]
			if not expected or #expected == 0 then
				return
			end
			local bufnr = ev.buf
			buf_state[bufnr] = buf_state[bufnr] or {}
			buf_timers[bufnr] = buf_timers[bufnr] or {}
			for _, name in ipairs(expected) do
				if buf_state[bufnr][name] == nil then
					buf_state[bufnr][name] = "starting"
					local timer = assert(vim.uv.new_timer())
					buf_timers[bufnr][name] = timer
					timer:start(
						STARTUP_TIMEOUT_MS,
						0,
						vim.schedule_wrap(function()
							if buf_state[bufnr] and buf_state[bufnr][name] == "starting" then
								buf_state[bufnr][name] = "unavailable"
								lsp_cache[bufnr] = nil
								vim.cmd("redrawstatus!")
							end
							clear_timer(bufnr, name)
						end)
					)
				end
			end
			lsp_cache[bufnr] = nil
		end,
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		group = group,
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if not client then
				return
			end
			local bufnr = ev.buf
			buf_state[bufnr] = buf_state[bufnr] or {}
			buf_state[bufnr][client.name] = "ready"
			clear_timer(bufnr, client.name)
			lsp_cache[bufnr] = nil
		end,
	})

	-- Fires for a client that crashed before it ever attached, not just for a
	-- clean stop of a working one -- confirmed in testing: a server whose cmd
	-- fails still gets an LspDetach for every buffer it was starting on. So
	-- detach always means "not attached now", i.e. unavailable, rather than
	-- "forget this server" (which mis-rendered a dead client as still
	-- starting forever, since render_lsp_groups's default state is "starting").
	vim.api.nvim_create_autocmd("LspDetach", {
		group = group,
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			local bufnr = ev.buf
			if client and buf_state[bufnr] then
				buf_state[bufnr][client.name] = "unavailable"
				clear_timer(bufnr, client.name)
			end
			lsp_cache[bufnr] = nil
		end,
	})

	-- $/progress is per-client, not per-buffer -- client.attached_buffers fans it
	-- out to every buffer that client has attached to. A begin/report
	-- also proves the client is alive, so it clears a still-pending startup
	-- timer even if this buffer's own LspAttach hasn't landed yet.
	--
	-- Once a client has reached "ready", a later begin/report must NOT drop it
	-- back to "loading" -- confirmed as the real bug behind "ruby_lsp… never
	-- goes away": ruby_lsp (and others) keep emitting $/progress for routine
	-- background work (re-indexing after an edit, etc.), not just the initial
	-- startup scan, so downgrading unconditionally never let the indicator
	-- settle. "loading" is now only for the pre-ready phase; a "ready" client
	-- stays "ready" through later progress, it just isn't shown as busy.
	vim.api.nvim_create_autocmd("LspProgress", {
		group = group,
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if not client then
				return
			end
			local kind = ev.data.params and ev.data.params.value and ev.data.params.value.kind
			for bufnr in pairs(client.attached_buffers or {}) do
				buf_state[bufnr] = buf_state[bufnr] or {}
				if kind == "end" then
					buf_state[bufnr][client.name] = "ready"
				elseif buf_state[bufnr][client.name] ~= "ready" then
					buf_state[bufnr][client.name] = "loading"
				end
				clear_timer(bufnr, client.name)
				lsp_cache[bufnr] = nil
			end
			vim.cmd("redrawstatus!")
		end,
	})

	vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
		group = group,
		callback = function(ev)
			clear_buf(ev.buf)
		end,
	})

	require("mini.statusline").setup({
		use_icons = true,
		content = {
			active = function()
				local bufnr = vim.api.nvim_get_current_buf()
				local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
				local git = MiniStatusline.section_git({ trunc_width = 75 })
				local filename = MiniStatusline.section_filename({ trunc_width = 140 })

				local lsp_groups = cached(lsp_cache, render_lsp_groups, bufnr)
				local ft = vim.bo.filetype
				local ft_text = #lsp_groups > 0 and ("\u{b7} " .. ft) or ft

				local groups = {
					{ hl = mode_hl, strings = { mode } },
					{ hl = "MiniStatuslineDevinfo", strings = { git } },
					"%<",
					{ hl = "MiniStatuslineFilename", strings = { filename } },
					"%=",
					cached(diag_cache, render_diagnostics, bufnr),
				}
				vim.list_extend(groups, lsp_groups)
				table.insert(groups, { hl = "MiniStatuslineDevinfo", strings = { ft_text } })
				table.insert(groups, { hl = mode_hl, strings = { "\u{f084f} %l/%L \u{f084e} %c/%{col('$')-1}" } })

				return MiniStatusline.combine_groups(groups)
			end,
		},
	})
end

return M
