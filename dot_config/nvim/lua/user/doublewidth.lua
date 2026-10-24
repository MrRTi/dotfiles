-- Flags characters that break cursor position/rendering in the terminal:
-- double-width glyphs (CJK, most emoji), U+FE0F (turns a width-1 symbol like ❤
-- into a width-2 emoji the terminal and Nvim may disagree on), and zero-width
-- characters (ZWJ, ZWSP). Plain non-ASCII that renders one cell wide (—, é, →,
-- Cyrillic) is fine and not flagged. <leader>fd collects the hits into the
-- quickfix list.

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

local VS16 = "\u{FE0F}"

-- Per-character verdict (message, or false when the character is fine). Cached
-- because the check goes through vim.fn and a Cyrillic or accented file repeats
-- the same few dozen characters thousands of times.
local verdicts = {}

local function verdict(char)
	local v = verdicts[char]
	if v == nil then
		local width = vim.fn.strdisplaywidth(char)
		if char == VS16 then
			-- Only reached for a stray selector with no symbol before it; a normal
			-- "❤️" arrives here as one unit (see collect) and measures width 2.
			v = "Emoji variation selector (makes the previous symbol double-width)"
		elseif width == 2 then
			v = "Double-width character"
		elseif width ~= 1 then
			-- Zero-width characters have no glyph, so Nvim shows them as <200d>
			-- (width 6) rather than 0; anything not 1 or 2 lands here.
			v = "Zero-width/invisible character"
		else
			v = false
		end
		verdicts[char] = v
	end
	return v
end

local function collect(lines)
	local diagnostics = {}
	for lnum, line in ipairs(lines) do
		if line:find("[\128-\255]") then
			-- NOTE: match a whole UTF-8 sequence (lead byte + continuation bytes) so
			-- one multibyte character yields one diagnostic. Matching bare bytes
			-- reported 3-4 hits per character and blew up the diagnostic count.
			-- A trailing U+FE0F is folded into the character before it: "❤" alone is
			-- width 1 but "❤️" is width 2, and checking the pair as one unit is what
			-- makes that visible. `skip_to` then steps over the selector itself.
			local skip_to = 0
			for col, char in line:gmatch("()([\194-\244][\128-\191]*)") do
				if col < skip_to then
					goto continue
				end
				if char ~= VS16 and line:sub(col + #char, col + #char + #VS16 - 1) == VS16 then
					char = char .. VS16
					skip_to = col + #char
				end
				local message = verdict(char)
				if message then
					diagnostics[#diagnostics + 1] = {
						lnum = lnum - 1,
						col = col - 1,
						end_col = col - 1 + #char,
						severity = vim.diagnostic.severity.WARN,
						message = message,
						source = "double-width",
					}
					if #diagnostics >= max_diagnostics then
						return diagnostics
					end
				end
				::continue::
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
		-- Search pattern built from the flagged characters themselves, so `n` and
		-- hlsearch hit exactly what the diagnostics do. No regex class can express
		-- "renders two cells wide".
		-- NOTE: \%U<hex> codepoint escapes, not the literal characters: Vim treats
		-- a lone U+FE0F as a combining mark and glues it onto whatever precedes it
		-- in the pattern (`\(` or `\|`), which silently broke the whole match.
		local seen, alts = {}, {}
		for _, d in ipairs(vim.diagnostic.get(0, { namespace = ns })) do
			local line = vim.api.nvim_buf_get_lines(0, d.lnum, d.lnum + 1, false)[1] or ""
			local char = line:sub(d.col + 1, d.end_col)
			if char ~= "" and not seen[char] then
				seen[char] = true
				local codepoints = {}
				for _, nr in ipairs(vim.fn.str2list(char)) do
					codepoints[#codepoints + 1] = ([[\%%U%08x]]):format(nr)
				end
				alts[#alts + 1] = table.concat(codepoints)
			end
		end
		if #alts > 0 then
			vim.fn.setreg("/", table.concat(alts, [[\|]]))
			vim.o.hlsearch = true
		end
		vim.diagnostic.setqflist({ namespace = ns, open = true })
	end, { desc = "Find double-width chars" })
end

return M
