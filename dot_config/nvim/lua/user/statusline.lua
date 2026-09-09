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

-- NOTE: used to filter out a "null-ls" client here; conform and nvim-lint call
-- their tools directly, so every client listed now is a real language server.
local function render_lsp(bufnr)
	local names = vim.tbl_map(function(c)
		return c.name
	end, vim.lsp.get_clients({ bufnr = bufnr }))
	return table.concat(names, " ")
end

local function cached(cache, render, bufnr)
	local value = cache[bufnr]
	if value == nil then
		value = render(bufnr)
		cache[bufnr] = value
	end
	return value
end

function M.setup()
	local group = vim.api.nvim_create_augroup("Statusline", { clear = true })

	vim.api.nvim_create_autocmd("DiagnosticChanged", {
		group = group,
		callback = function(ev)
			diag_cache[ev.buf] = nil
		end,
	})

	vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
		group = group,
		callback = function(ev)
			lsp_cache[ev.buf] = nil
		end,
	})

	vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
		group = group,
		callback = function(ev)
			diag_cache[ev.buf] = nil
			lsp_cache[ev.buf] = nil
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

				local lsp = cached(lsp_cache, render_lsp, bufnr)
				local ft = vim.bo.filetype
				local lsp_ft = lsp ~= "" and (lsp .. " \u{b7} " .. ft) or ft

				return MiniStatusline.combine_groups({
					{ hl = mode_hl, strings = { mode } },
					{ hl = "MiniStatuslineDevinfo", strings = { git } },
					"%<",
					{ hl = "MiniStatuslineFilename", strings = { filename } },
					"%=",
					cached(diag_cache, render_diagnostics, bufnr),
					{ hl = "MiniStatuslineDevinfo", strings = { lsp_ft } },
					{ hl = mode_hl, strings = { "\u{f084f} %l/%L \u{f084e} %c/%{col('$')-1}" } },
				})
			end,
		},
	})
end

return M
