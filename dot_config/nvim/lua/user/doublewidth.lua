-- Flags non-ASCII characters as diagnostics, since double-width glyphs misalign
-- terminal output. <leader>fd collects the hits into the quickfix list.

local M = {}

local ns = vim.api.nvim_create_namespace("double_width_chars")

-- Cap on how many hits get reported. vim.diagnostic.set is O(n) in redraw work,
-- so an unbounded list on a unicode-heavy file froze the UI for hundreds of ms.
local max_diagnostics = 200
-- Above this the whole-buffer scan itself is the cost, not the diagnostic list:
-- collect() walks every line on every TextChanged, so a very large file would
-- burn a full pass every debounce window while typing.
local max_lines = 20000
local debounce_ms = 150
local timers = {}

local function collect(lines)
	local diagnostics = {}
	for lnum, line in ipairs(lines) do
		if line:find("[\128-\255]") then
			-- NOTE: match a whole UTF-8 sequence (lead byte + continuation bytes) so
			-- one multibyte character yields one diagnostic. Matching bare bytes
			-- reported 3-4 hits per character and blew up the diagnostic count.
			for col, char in line:gmatch("()([\194-\244][\128-\191]*)") do
				diagnostics[#diagnostics + 1] = {
					lnum = lnum - 1,
					col = col - 1,
					end_col = col - 1 + #char,
					severity = vim.diagnostic.severity.WARN,
					message = "Non-ASCII character (double-width risk)",
					source = "double-width",
				}
				if #diagnostics >= max_diagnostics then
					return diagnostics
				end
			end
		end
	end
	return diagnostics
end

local function check(bufnr)
	-- Only real file buffers: skips directory listings (nvim.dir sets buftype =
	-- "nowrite"), fzf-lua previews, terminals and other scratch buffers that used
	-- to get a full scan on every BufEnter.
	if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "" then
		return
	end
	if vim.api.nvim_buf_line_count(bufnr) > max_lines then
		return
	end
	vim.diagnostic.set(ns, bufnr, collect(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)))
end

local function schedule(bufnr)
	local timer = timers[bufnr]
	if not timer then
		-- nil when the event loop is out of handles (EMFILE and friends).
		-- Skipping the scan is the right failure mode here: the diagnostics
		-- are advisory, and the next TextChanged retries.
		timer = vim.uv.new_timer()
		if not timer then
			return
		end
		timers[bufnr] = timer
	end
	timer:stop()
	timer:start(debounce_ms, 0, function()
		vim.schedule(function()
			check(bufnr)
		end)
	end)
end

function M.setup()
	local group = vim.api.nvim_create_augroup("DoubleWidth", { clear = true })

	-- BufReadPost, not BufEnter: content only changes on load or edit, so
	-- re-scanning on every buffer switch was pure waste.
	vim.api.nvim_create_autocmd({ "BufReadPost", "TextChanged", "InsertLeave" }, {
		group = group,
		callback = function(ev)
			schedule(ev.buf)
		end,
	})

	vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
		group = group,
		callback = function(ev)
			local timer = timers[ev.buf]
			if timer then
				timer:stop()
				timer:close()
				timers[ev.buf] = nil
			end
		end,
	})

	vim.keymap.set("n", "<leader>fd", function()
		vim.fn.setreg("/", [=[[^\x00-\x7E]]=])
		vim.o.hlsearch = true
		vim.diagnostic.setqflist({ namespace = ns, open = true })
	end, { desc = "Find double-width chars" })
end

return M
