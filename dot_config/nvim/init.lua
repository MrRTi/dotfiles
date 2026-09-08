-- Startup timing: hrtime taken here, read again on VimEnter and echoed under the
-- intro screen. Misses the ~9 ms nvim spends before it starts sourcing this file,
-- so it reads slightly low against `nvim --startuptime`.
local start_time = vim.uv.hrtime()

-- Options

vim.g.mapleader = " "

vim.o.number = true
vim.o.relativenumber = false
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.swapfile = false
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
-- NOTE: no `vim.o.background` here on purpose. The TUI queries the terminal
-- (OSC 11) at startup and sets it from the real background colour, so setting
-- it explicitly would clobber that. See the Appearance section.

vim.opt.scrolloff = 999
-- NOTE: horizontal scrolling starts once the cursor passes (text area - sidescrolloff),
-- and from then on every column move repaints the whole window. At 999 the cursor is
-- pinned mid-window, so that point is *half* the text area -- a 62-char line already
-- scrolls in a 130-col terminal, and a vertical split drops it to ~col 36. At 20 the
-- trigger tracks the window edge instead, so ordinary lines never scroll while still
-- keeping 20 columns of lookahead. Costs the horizontal centering `scrolloff = 999`
-- gives vertically.
vim.opt.sidescrolloff = 20
vim.opt.cursorline = true

-- NOTE: Default indent: 2 spaces (covers ruby, lua, yaml, json, javascript, shell)
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

local indent_overrides = {
	python = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true },
	go = { tabstop = 8, shiftwidth = 8, softtabstop = 0, expandtab = false },
	make = { tabstop = 8, shiftwidth = 8, softtabstop = 0, expandtab = false },
	dockerfile = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true },
}

for filetype, opts in pairs(indent_overrides) do
	vim.api.nvim_create_autocmd("FileType", {
		pattern = filetype,
		callback = function()
			vim.bo.tabstop = opts.tabstop
			vim.bo.shiftwidth = opts.shiftwidth
			vim.bo.softtabstop = opts.softtabstop
			vim.bo.expandtab = opts.expandtab
		end,
	})
end

-- Folds via treesitter; start with all folds open
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldenable = false
vim.o.foldlevel = 99

-- Plugins

vim.keymap.set("n", "<leader>pu", function()
	vim.pack.update()
end, { desc = "Update plugins" })

vim.pack.add({
	-- mini.statusline is drawn immediately, so it stays eager. The other three
	-- mini modules only act on buffer contents -- see lazy_pack below.
	{ src = "https://github.com/echasnovski/mini.statusline" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/folke/which-key.nvim" },
	-- deps
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	-- Theme
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
})

-- NOTE: vim.pack has no lazy-loading of its own, and `load = false` is not it:
-- that only skips `:packadd`'s own sourcing, while Nvim still sources the
-- plugin's `plugin/` files at the normal rtp stage. That is how gitsigns loads
-- itself no matter what -- its plugin/gitsigns.lua is a bare
-- `require('gitsigns').setup()`. Passing a `load` *function* instead makes us
-- "fully responsible for loading" (:h vim.pack.keyset.add), so the plugin stays
-- off the runtimepath until lazy_load() runs `:packadd` for it.
--
-- Measured: deferring these six takes startup from 60 ms to ~36 ms with no file
-- argument. Each `lazy_setup[name]` lives next to that plugin's own config
-- below, so nothing moves except when it runs.
local lazy_setup, lazy_loaded = {}, {}

local function lazy_pack(name, spec)
	vim.pack.add({ spec }, { load = function() end })
	return name
end

local function lazy_load(name)
	if lazy_loaded[name] then
		return
	end
	lazy_loaded[name] = true
	vim.cmd.packadd(name)
	local setup = lazy_setup[name]
	if setup then
		setup()
	end
end

lazy_pack("oil.nvim", { src = "https://github.com/stevearc/oil.nvim" })
lazy_pack("fzf-lua", { src = "https://github.com/ibhagwan/fzf-lua" })
lazy_pack("gitsigns.nvim", { src = "https://github.com/lewis6991/gitsigns.nvim" })
lazy_pack("todo-comments.nvim", { src = "https://github.com/folke/todo-comments.nvim" })
lazy_pack("conform.nvim", { src = "https://github.com/stevearc/conform.nvim" })
lazy_pack("nvim-lint", { src = "https://github.com/mfussenegger/nvim-lint" })
lazy_pack("mini.ai", { src = "https://github.com/echasnovski/mini.ai" })
lazy_pack("mini.splitjoin", { src = "https://github.com/echasnovski/mini.splitjoin" })
lazy_pack("mini.indentscope", { src = "https://github.com/echasnovski/mini.indentscope" })
lazy_pack("harpoon", {
	src = "https://github.com/ThePrimeagen/harpoon",
	version = "harpoon2",
})

-- Plugins that only matter once there is a real buffer. BufReadPre fires before
-- filetype detection, so nvim-lint's BufReadPost hook still fires for the very
-- first file -- registering it any later would miss that buffer.
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	once = true,
	callback = function()
		lazy_load("gitsigns.nvim")
		lazy_load("todo-comments.nvim")
		lazy_load("conform.nvim")
		lazy_load("nvim-lint")
	end,
})

-- Editing helpers that only act on buffer contents. InsertEnter is in the list
-- so they also come up in a scratch buffer typed into straight from the intro
-- screen, which fires neither BufReadPre nor BufNewFile.
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile", "InsertEnter" }, {
	once = true,
	callback = function()
		lazy_load("mini.ai")
		lazy_load("mini.splitjoin")
		lazy_load("mini.indentscope")
	end,
})

-- Appearance

-- NOTE: 'background' is detected by the TUI, which queries the terminal for its
-- background colour (OSC 11) at startup. Ghostty follows the macOS appearance
-- (theme = dark:...,light:... in its config), so nvim tracks the system theme for
-- free. This replaced an is_dark_local() helper that shelled out to `osascript`:
-- that call blocked startup for ~104 ms, about half of total startup time.
-- Verify with `:echo &background` under both macOS appearances.
local function toggle_appearance(toggle_to)
	toggle_to = toggle_to or (vim.o.background == "light" and "dark" or "light")
	vim.o.background = toggle_to
end

require("kanagawa").setup({
	transparent = true,
	background = { dark = "dragon", light = "lotus" },
})
vim.cmd("colorscheme kanagawa")

vim.cmd("hi NormalFloat guibg=NONE")
vim.cmd("hi FloatBorder guibg=NONE")

-- UI

lazy_setup["todo-comments.nvim"] = function()
	require("todo-comments").setup()
end

lazy_setup["mini.ai"] = function()
	require("mini.ai").setup()
end

lazy_setup["mini.splitjoin"] = function()
	require("mini.splitjoin").setup()
end

lazy_setup["mini.indentscope"] = function()
	require("mini.indentscope").setup()
end

-- NOTE: the statusline redraws on every cursor move, so counting diagnostics
-- inline made each redraw cost O(#diagnostics). Render once when diagnostics
-- actually change and let the statusline read the cached string.
local diag_status = {}

local function render_diag_status(bufnr)
	local labels = {
		{ "E", "DiagnosticError" },
		{ "W", "DiagnosticWarn" },
		{ "I", "DiagnosticInfo" },
		{ "H", "DiagnosticHint" },
	}
	local counts = vim.diagnostic.count(bufnr)
	local parts = {}
	for sev, v in ipairs(labels) do
		local n = counts[sev] or 0
		if n > 0 then
			table.insert(parts, string.format("%%#%s#%s:%d", v[2], v[1], n))
		end
	end
	return #parts > 0 and (" " .. table.concat(parts, " ") .. " %#MiniStatuslineDevinfo#") or ""
end

vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufEnter" }, {
	callback = function(ev)
		if vim.api.nvim_buf_is_valid(ev.buf) then
			diag_status[ev.buf] = render_diag_status(ev.buf)
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
	callback = function(ev)
		diag_status[ev.buf] = nil
	end,
})

local function colored_diagnostics()
	return diag_status[vim.api.nvim_get_current_buf()] or ""
end

local function lsp_clients()
	-- NOTE: used to filter out a "null-ls" client here; conform and nvim-lint call
	-- their tools directly, so every client listed now is a real language server.
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	return #clients > 0 and table.concat(
		vim.tbl_map(function(c)
			return c.name
		end, clients),
		" "
	) or ""
end

require("mini.statusline").setup({
	use_icons = true,
	content = {
		active = function()
			local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
			local git = MiniStatusline.section_git({ trunc_width = 75 })
			local filename = MiniStatusline.section_filename({ trunc_width = 140 })
			local location = MiniStatusline.section_location({ trunc_width = 75 })

			local lsp = lsp_clients()
			local ft = vim.bo.filetype
			local lsp_ft = lsp ~= "" and (lsp .. " · " .. ft) or ft

			return MiniStatusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = "MiniStatuslineDevinfo", strings = { git } },
				"%<",
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=",
				colored_diagnostics(),
				{ hl = "MiniStatuslineDevinfo", strings = { lsp_ft } },
				{ hl = mode_hl, strings = { "󰡏 %l/%L 󰡎 %c/%{col('$')-1}" } },
			})
		end,
	},
})

require("which-key").setup()
require("which-key").add({
	{ "<leader>b", group = "buffer" },
	{ "<leader>f", group = "file" },
	{ "<leader>g", group = "git" },
	{ "<leader>l", group = "lsp" },
	{ "<leader>s", group = "search" },
	{ "<leader>p", group = "plugins" },
	{ "<leader>u", group = "ui" },
	{ "[", group = "prev" },
	{ "]", group = "next" },
})

vim.keymap.set("n", "<leader>ut", toggle_appearance, { desc = "Toggle light/dark" })
vim.keymap.set("n", "<leader>uT", function()
	local buf = vim.api.nvim_get_current_buf()
	if vim.treesitter.highlighter.active[buf] then
		vim.treesitter.stop()
	else
		vim.treesitter.start()
	end
end, { desc = "Toggle treesitter highlight" })

-- File explorer

lazy_setup["oil.nvim"] = function()
	require("oil").setup({
		view_options = { show_hidden = true },
	})
end

-- NOTE: oil ships no plugin/ dir, so `:Oil` only exists once its setup has run.
local function oil_open()
	lazy_load("oil.nvim")
	vim.cmd("Oil")
end

vim.keymap.set("n", "<leader>e", oil_open, { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>-", oil_open, { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>fp", '<cmd>let @+ = fnamemodify(expand("%:p"), ":~:.")<CR>', { desc = "Copy path" })

-- Search

local fzf_grep_normal = {
	rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
	header = ":: <ctrl-g> to Fuzzy Search | :: <alt-m> to Multiline Mode",
}
local fzf_grep_multiline = {
	rg_opts = "--multiline --column --line-number --no-heading --color=always --smart-case",
	header = ":: <ctrl-g> to Fuzzy Search | :: <alt-m> to Normal Mode",
}
fzf_grep_normal.actions = {
	["alt-m"] = function(_, _)
		require("fzf-lua").live_grep(vim.tbl_extend("force", fzf_grep_multiline, { resume = true }))
	end,
}
fzf_grep_multiline.actions = {
	["alt-m"] = function(_, _)
		require("fzf-lua").live_grep(vim.tbl_extend("force", fzf_grep_normal, { resume = true }))
	end,
}
lazy_setup["fzf-lua"] = function()
	require("fzf-lua").setup({
		winopts = { preview = { layout = "vertical" } },
		grep = fzf_grep_normal,
		keymap = {
			fzf = {
				true,
				-- NOTE: Use <c-q> to select all items and add them to the quickfix list
				["ctrl-q"] = "select-all+accept",
			},
		},
	})
end

-- NOTE: :FzfLua comes from fzf-lua's own plugin/ file, which `:packadd` sources,
-- but the winopts/grep config above only lands once setup has run -- so the
-- keymaps must go through lazy_load rather than calling :FzfLua directly.
local function fzf(subcommand)
	return function()
		lazy_load("fzf-lua")
		vim.cmd("FzfLua " .. subcommand)
	end
end

vim.keymap.set("n", "<leader><space>", fzf("global"), { desc = "Search files and buffers" })
vim.keymap.set("n", "<leader>sf", fzf("files"), { desc = "Files" })
vim.keymap.set("n", "<leader>sg", fzf("live_grep"), { desc = "Live grep" })
vim.keymap.set("n", "<leader>sw", fzf("grep_cword"), { desc = "Word under cursor" })
vim.keymap.set("n", "<leader>sh", fzf("helptags"), { desc = "Help tags" })
vim.keymap.set("n", "<leader>sk", fzf("keymaps"), { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sr", fzf("resume"), { desc = "Resume last search" })
vim.keymap.set("n", "<leader>st", function()
	lazy_load("todo-comments.nvim")
	lazy_load("fzf-lua")
	vim.cmd("TodoFzfLua")
end, { desc = "Search todos/notes" })

-- Treesitter
-- NOTE: nvim-treesitter main branch (Neovim 0.12+) only manages parser installation.
-- Highlighting is handled natively by Neovim.

-- NOTE: install() re-checks every parser against the registry, which cost 2.6 ms
-- on *every* startup to confirm parsers that were already on disk. Parsers only
-- need installing when this list changes, so it is a command now. Run
-- :TSInstallParsers after editing the list (or on a fresh machine).
local ts_parsers = {
	"lua",
	"ruby",
	"python",
	"javascript",
	"yaml",
	"json",
	"go",
	"markdown",
	"markdown_inline",
}

vim.api.nvim_create_user_command("TSInstallParsers", function()
	require("nvim-treesitter").install(ts_parsers)
end, { desc = "Install the treesitter parsers this config expects" })

-- LSP

-- NOTE: library is VIMRUNTIME only, not nvim_get_runtime_file("", true). Passing the
-- whole runtimepath hands lua_ls every installed plugin -- 3849 .lua files, 19.1 MB --
-- and it never reaches "Preload finish"; RSS peaks at ~765 MB vs ~287 MB, and the
-- workspace stays unusable far longer. lspconfig's own lua_ls docs flag that exact
-- call as "a lot slower" (neovim/nvim-lspconfig#3189). Trade-off: no completion or
-- gd into plugin source, so `require("fzf-lua")` resolves to nothing. Add specific
-- plugin dirs here if a particular API is worth the indexing cost.
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT", path = { "lua/?.lua", "lua/?/init.lua" } },
			workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
		},
	},
})

vim.lsp.enable({ "lua_ls", "ruby_lsp", "pyright", "ruff", "yamlls", "marksman", "gopls" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.server_capabilities.completionProvider then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
		-- ruff is the sole Python formatter (conform's formatters_by_ft below
		-- intentionally has no python entry, and no black/isort) — wire its
		-- format-on-save here since it's a plain LSP client.
		if client and client.name == "ruff" and client.server_capabilities.documentFormattingProvider then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = ev.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = ev.buf, id = client.id })
				end,
			})
		end
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		for _, client in ipairs(vim.lsp.get_clients()) do
			client:stop()
		end
	end,
})

-- Built-in LSP completion: fuzzy matching, show menu, don't auto-insert
vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect", "fuzzy" }

-- NOTE: grr (references), grn (rename), gra (code action), gri (implementation)
--       are Neovim 0.11 built-ins and appear in which-key automatically.
vim.keymap.set({ "n", "v" }, "<leader>lf", function()
	lazy_load("conform.nvim")
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Diagnostic float" })
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })

-- Formatting & diagnostics

-- NOTE: replaced none-ls.nvim (plus none-ls-extras and none-ls-shellcheck).
-- none-ls bridges CLI tools by standing up a fake LSP client; conform and
-- nvim-lint invoke them directly. Three plugins became two, and the work moved
-- off startup entirely -- see the BufReadPre trigger above.
lazy_setup["conform.nvim"] = function()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			ruby = { "rubocop" },
			json = { "jq" },
			yaml = { "yamlfmt" },
			sh = { "shfmt" },
			bash = { "shfmt" },
		},
		-- NOTE: lsp_format = "never" on purpose. Python is formatted by ruff via its
		-- own LspAttach hook above; letting conform fall back to LSP here would run
		-- both and format the buffer twice. Manual <leader>lf below still falls back
		-- to LSP, which is what formats go/python on demand.
		format_on_save = { timeout_ms = 3000, lsp_format = "never" },
	})
end

lazy_setup["nvim-lint"] = function()
	local lint = require("lint")
	lint.linters_by_ft = {
		ruby = { "rubocop" },
		sh = { "shellcheck" },
		bash = { "shellcheck" },
	}
	-- NOTE: registered during BufReadPre, so the BufReadPost for the file that
	-- triggered this load still fires afterwards and lints it.
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
		group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
		callback = function()
			lint.try_lint()
		end,
	})
end

-- Navigation (tmux + harpoon)

-- NOTE: Tmux-aware pane navigation (replaces vim-tmux-navigator plugin)
local function tmux_navigate(direction)
	local tmux_dir = ({ h = "L", j = "D", k = "U", l = "R" })[direction]
	local win = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. direction)
	if vim.api.nvim_get_current_win() == win and vim.env.TMUX then
		vim.fn.system("tmux select-pane -" .. tmux_dir)
	end
end

for _, dir in ipairs({ "h", "j", "k", "l" }) do
	vim.keymap.set("n", "<C-" .. dir .. ">", function()
		tmux_navigate(dir)
	end, { desc = "Navigate " .. dir })
end

lazy_setup["harpoon"] = function()
	require("harpoon").setup()
end

-- NOTE: harpoon is resolved per keypress rather than held in an upvalue, so the
-- plugin stays unloaded until one of these maps is actually used.
local function harpoon_do(fn)
	return function()
		lazy_load("harpoon")
		fn(require("harpoon"))
	end
end

vim.keymap.set(
	"n",
	"<leader>H",
	harpoon_do(function(h)
		h:list():add()
	end),
	{ desc = "Add file to harpoon" }
)
vim.keymap.set(
	"n",
	"<leader>h",
	harpoon_do(function(h)
		h.ui:toggle_quick_menu(h:list())
	end),
	{ desc = "Toggle harpoon menu" }
)
vim.keymap.set(
	"n",
	"[H",
	harpoon_do(function(h)
		h:list():prev()
	end),
	{ desc = "Previous harpoon file" }
)
vim.keymap.set(
	"n",
	"]H",
	harpoon_do(function(h)
		h:list():next()
	end),
	{ desc = "Next harpoon file" }
)

-- Git

-- NOTE: no lazy_setup entry needed -- gitsigns' own plugin/gitsigns.lua is a bare
-- `require('gitsigns').setup()`, so `:packadd` from the BufReadPre trigger above
-- configures it. Its keymaps below are :Gitsigns subcommands, which that same
-- plugin/ file registers, so they resolve once a buffer has been read.

vim.keymap.set("n", "<leader>gg", function()
	vim.cmd("tabnew | terminal lazygit")
	vim.cmd("startinsert")
	vim.api.nvim_create_autocmd("TermClose", {
		buffer = 0,
		callback = function()
			vim.cmd("bdelete!")
		end,
	})
end, { desc = "LazyGit" })
vim.keymap.set({ "n", "v" }, "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame line" })
vim.keymap.set({ "n", "v" }, "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Preview hunk" })
vim.keymap.set({ "n", "v" }, "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", { desc = "Stage buffer" })
vim.keymap.set("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Undo stage hunk" })
vim.keymap.set("n", "<leader>gq", "<cmd>Gitsigns setqflist<CR>", { desc = "Hunks to quickfix" })
vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous hunk" })
vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next hunk" })

-- Buffer

vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Autocmds

local dw_ns = vim.api.nvim_create_namespace("double_width_chars")

-- Cap on how many hits get reported. vim.diagnostic.set is O(n) in redraw work,
-- so an unbounded list on a unicode-heavy file froze the UI for hundreds of ms.
local dw_max_diagnostics = 200
local dw_debounce_ms = 150
local dw_timers = {}

local function dw_collect(lines)
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
				if #diagnostics >= dw_max_diagnostics then
					return diagnostics
				end
			end
		end
	end
	return diagnostics
end

local function check_double_width(bufnr)
	-- Only real file buffers: skips oil listings, fzf-lua previews, terminals and
	-- other scratch buffers that used to get a full scan on every BufEnter.
	if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "" then
		return
	end
	vim.diagnostic.set(dw_ns, bufnr, dw_collect(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)))
end

local function schedule_double_width(bufnr)
	local timer = dw_timers[bufnr]
	if not timer then
		timer = vim.uv.new_timer()
		dw_timers[bufnr] = timer
	end
	timer:stop()
	timer:start(dw_debounce_ms, 0, function()
		vim.schedule(function()
			check_double_width(bufnr)
		end)
	end)
end

-- BufReadPost, not BufEnter: content only changes on load or edit, so re-scanning
-- on every buffer switch was pure waste.
vim.api.nvim_create_autocmd({ "BufReadPost", "TextChanged", "InsertLeave" }, {
	callback = function(ev)
		schedule_double_width(ev.buf)
	end,
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
	callback = function(ev)
		local timer = dw_timers[ev.buf]
		if timer then
			timer:stop()
			timer:close()
			dw_timers[ev.buf] = nil
		end
	end,
})

vim.keymap.set("n", "<leader>fd", function()
	vim.fn.setreg("/", [=[[^\x00-\x7E]]=])
	vim.o.hlsearch = true
	vim.diagnostic.setqflist({ namespace = dw_ns, open = true })
end, { desc = "Find double-width chars" })

vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.hl.hl_op({ higroup = "IncSearch", timeout = 200 })
	end,
})

-- Startup report, echoed under the intro screen. Skipped when nvim was given a
-- file (no intro to annotate) or has no UI (--headless).
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() > 0 or #vim.api.nvim_list_uis() == 0 then
			return
		end
		-- NOTE: vim.pack.get() defaults to info = true, which shells out to git for
		-- every plugin's branches and tags -- 363 ms here. info = false is a plain
		-- read of the already-loaded specs, 0.1 ms.
		-- NOTE: filtered on `active`, since get() also reports plugins still on disk
		-- under pack/core/opt that vim.pack.add no longer lists.
		local plugins = 0
		for _, p in ipairs(vim.pack.get(nil, { info = false })) do
			if p.active then
				plugins = plugins + 1
			end
		end
		local ms = (vim.uv.hrtime() - start_time) / 1e6
		-- NOTE: scheduled so the echo lands after the intro screen is drawn;
		-- echoing inside VimEnter itself suppresses it.
		vim.schedule(function()
			vim.api.nvim_echo({
				{ "startup took ", "Comment" },
				{ string.format("%.0f ms", ms), "Title" },
				{ string.format("  \u{b7}  %d plugins", plugins), "Comment" },
			}, false, {})
		end)
	end,
})
