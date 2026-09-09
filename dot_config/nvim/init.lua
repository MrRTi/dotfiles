-- Startup timing: hrtime taken here, read again on VimEnter and echoed under the
-- intro screen. Misses the ~9 ms nvim spends before it starts sourcing this file,
-- so it reads slightly low against `nvim --startuptime`.
local start_time = vim.uv.hrtime()

-- Byte-compile cache for Lua modules, kept in stdpath("cache")/luac and
-- invalidated automatically when a file changes. Not on by default; this is the
-- same cache lazy.nvim turns on for you, which is most of what a plugin manager
-- buys performance-wise. Measured -15%: 29 -> 25 ms with no file, 54 -> 45 ms
-- opening one. Documented as "experimental" but the API is stable (@since 0).
-- Placed after start_time so the startup report includes its own cost.
vim.loader.enable()

-- Options

-- NOTE: netrw is legacy in 0.13 (moved to an optional package; `:packadd netrw`)
-- and Nvim's own nvim.dir browser replaces it. Nvim normally suppresses netrw by
-- clearing the FileExplorer augroup from runtime/plugin/dir.lua, but under this
-- config netrw ends up registering *after* that clear, leaving both live. They
-- then race for the same directory buffer: nvim.dir renames its buffer with
-- `:file <dir>` while netrw has already claimed that name, so `-` on a file
-- buffer died with "E95: Buffer with this name already exists".
-- Setting these makes runtime/plugin/netrwPlugin.vim bail before `packadd netrw`.
-- Directories are then handled by Nvim's built-in nvim.dir browser.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

-- NOTE: managed by lazy.nvim, after a stint on Nvim's built-in vim.pack.
-- vim.pack is fine and its lockfile is native, but it has no lazy-loading.
-- `load = false` is not it -- that only skips `:packadd`'s own sourcing while
-- Nvim still sources the plugin's `plugin/` files at the normal rtp stage (which
-- is how gitsigns loaded itself regardless: its plugin/gitsigns.lua is a bare
-- `require('gitsigns').setup()`). The only real lever is handing `add()` a
-- `load` *function* and taking over loading yourself, which came to ~80 lines of
-- bespoke helper plus one `lazy_setup[name]` wrapper per plugin -- each sitting
-- far from the trigger that fired it, joined only by a name string.
--
-- That distance caused actual bugs: `<cmd>FzfLua files<CR>` ran before its own
-- setup and silently lost the winopts/grep config, a `local harpoon =
-- require(...)` upvalue defeated the deferral entirely, and a scratch buffer
-- typed into from the intro screen loaded none of the editing modules. `keys =`
-- next to `config =` makes all three impossible to express.
--
-- Startup was benchmarked both ways on this exact config -- isolated XDG dirs,
-- same eager/deferred split, median of 15 runs: 24.65 ms (vim.pack) vs 24.26 ms
-- (lazy) with no file, 41.40 vs 41.66 opening one. A dead heat, inside
-- run-to-run noise. So this move buys readability at no measurable cost; it is
-- not a performance change.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		error("Could not clone lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.keymap.set("n", "<leader>pu", "<cmd>Lazy update<CR>", { desc = "Update plugins" })

require("lazy").setup({
	-- Eager. Each of these is needed before the first redraw, so there is nothing
	-- to defer; their setup() calls stay in the sections below that own them.
	{ "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
	{ "echasnovski/mini.statusline", lazy = false },
	{ "folke/which-key.nvim", lazy = false },
	-- Supplies the lsp/*.lua server definitions vim.lsp.enable() reads, so it only
	-- has to be on the runtimepath -- nothing requires it.
	{ "neovim/nvim-lspconfig", lazy = false },
	-- On `main` this only installs parsers; highlighting is native. Needed just for
	-- :TSInstallParsers below.
	{ "nvim-treesitter/nvim-treesitter", branch = "main", lazy = false },

	-- Deferred until a key is pressed.
	{
		"ibhagwan/fzf-lua",
		keys = {
			{ "<leader><space>", "<cmd>FzfLua global<CR>", desc = "Search files and buffers" },
			{ "<leader>sf", "<cmd>FzfLua files<CR>", desc = "Files" },
			-- NOTE: git_files lists via `git ls-files` instead of `fd`. Measured no
			-- difference in open latency (120 ms vs 121 ms on a 14k-file repo, since
			-- fzf-lua streams either way), and it returned 0 results in a git-worktree
			-- checkout -- here to compare against <leader>sf.
			{ "<leader>sF", "<cmd>FzfLua git_files<CR>", desc = "Files (git)" },
			{ "<leader>sg", "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },
			{ "<leader>sw", "<cmd>FzfLua grep_cword<CR>", desc = "Word under cursor" },
			{ "<leader>sh", "<cmd>FzfLua helptags<CR>", desc = "Help tags" },
			{ "<leader>sk", "<cmd>FzfLua keymaps<CR>", desc = "Keymaps" },
			{ "<leader>sr", "<cmd>FzfLua resume<CR>", desc = "Resume last search" },
		},
		config = function()
			-- The two grep modes swap into each other via <alt-m>, so each needs a
			-- reference to the other -- hence the tables before .actions is filled in.
			local normal = {
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
				header = ":: <ctrl-g> to Fuzzy Search | :: <alt-m> to Multiline Mode",
			}
			local multiline = {
				rg_opts = "--multiline --column --line-number --no-heading --color=always --smart-case",
				header = ":: <ctrl-g> to Fuzzy Search | :: <alt-m> to Normal Mode",
			}
			normal.actions = {
				["alt-m"] = function()
					require("fzf-lua").live_grep(vim.tbl_extend("force", multiline, { resume = true }))
				end,
			}
			multiline.actions = {
				["alt-m"] = function()
					require("fzf-lua").live_grep(vim.tbl_extend("force", normal, { resume = true }))
				end,
			}
			require("fzf-lua").setup({
				-- <leader><space> is the `global` picker: a prefix-switched combination of
				-- sources. Defaults are no-prefix = files, `$` = buffers, `@` = symbols in
				-- the current buffer, `#` = symbols across the project (the last two fall
				-- back to btags/tags when no LSP client supports them). `%` adds git-tracked
				-- files, which unlike the fd-backed default leaves out untracked ones.
				--
				-- NOTE: the default `pickers` is a *function*, evaluated per invocation so it
				-- can branch on which LSP methods the attached clients support. Call it and
				-- append rather than replacing the list, or `@` and `#` lose that branching.
				global = {
					pickers = function()
						local pickers = require("fzf-lua.defaults").defaults.global.pickers()
						table.insert(pickers, { "git_files", desc = "Git files", prefix = "%" })
						return pickers
					end,
				},
				winopts = { preview = { layout = "vertical" } },
				grep = normal,
				keymap = {
					fzf = {
						true,
						-- NOTE: Use <c-q> to select all items and add them to the quickfix list
						["ctrl-q"] = "select-all+accept",
					},
				},
			})
		end,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		keys = {
			{
				"<leader>H",
				function()
					require("harpoon"):list():add()
				end,
				desc = "Add file to harpoon",
			},
			{
				"<leader>h",
				function()
					local h = require("harpoon")
					h.ui:toggle_quick_menu(h:list())
				end,
				desc = "Toggle harpoon menu",
			},
			{
				"[H",
				function()
					require("harpoon"):list():prev()
				end,
				desc = "Previous harpoon file",
			},
			{
				"]H",
				function()
					require("harpoon"):list():next()
				end,
				desc = "Next harpoon file",
			},
		},
	},

	-- Deferred until there is a real buffer. BufReadPre (not BufReadPost) so
	-- nvim-lint's own BufReadPost hook still fires for the very first file.
	-- NOTE: gitsigns needs no opts here -- its plugin/gitsigns.lua, which lazy
	-- sources on load, is itself a bare `require('gitsigns').setup()`. Passing
	-- opts as well would just run setup twice.
	{ "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" } },
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
		keys = {
			{
				"<leader>st",
				function()
					-- :TodoFzfLua is todo-comments' command but needs fzf-lua present.
					require("lazy").load({ plugins = { "fzf-lua" } })
					vim.cmd("TodoFzfLua")
				end,
				desc = "Search todos/notes",
			},
		},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{
				"<leader>lf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = { "n", "v" },
				desc = "Format",
			},
		},
		-- NOTE: replaced none-ls.nvim (plus none-ls-extras and none-ls-shellcheck),
		-- which bridged these same CLI tools by standing up a fake LSP client.
		-- conform and nvim-lint invoke them directly: three plugins became two.
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				ruby = { "rubocop" },
				json = { "jq" },
				yaml = { "yamlfmt" },
				sh = { "shfmt" },
				bash = { "shfmt" },
			},
			-- NOTE: lsp_format = "never" on purpose. Python is formatted by ruff via
			-- its own LspAttach hook below; letting conform fall back to LSP here
			-- would run both and format the buffer twice. The <leader>lf map above
			-- does fall back to LSP, which is what formats go/python on demand.
			format_on_save = { timeout_ms = 3000, lsp_format = "never" },
		},
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				ruby = { "rubocop" },
				sh = { "shellcheck" },
				bash = { "shellcheck" },
			}
			vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
				group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	-- Editing helpers that only act on buffer contents. InsertEnter is in the list
	-- so they also come up in a scratch buffer typed into straight from the intro
	-- screen, which fires neither BufReadPre nor BufNewFile.
	{ "echasnovski/mini.ai", event = { "BufReadPre", "BufNewFile", "InsertEnter" }, opts = {} },
	{ "echasnovski/mini.splitjoin", event = { "BufReadPre", "BufNewFile", "InsertEnter" }, opts = {} },
	{ "echasnovski/mini.indentscope", event = { "BufReadPre", "BufNewFile", "InsertEnter" }, opts = {} },
}, {
	-- Lives next to init.lua so chezmoi manages it, replacing nvim-pack-lock.json.
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
	-- The config is chezmoi-deployed, so it changes under Nvim on every `chezmoi
	-- apply`; the reload prompt that would cause is noise.
	change_detection = { enabled = false },
	-- Nothing here needs luarocks, and leaving it on makes :checkhealth fail on a
	-- missing hererocks install.
	rocks = { enabled = false },
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

-- NOTE: no keymaps here on purpose. Nvim 0.13's built-in nvim.dir browser
-- (which replaced oil.nvim) already provides a global `-` for the parent
-- directory -- from a file buffer, from a listing, and from a no-name buffer,
-- where it falls back to the cwd. It takes a count, so `1-` jumps to the cwd and
-- `2-` goes up two levels. Inside a listing: `<CR>` opens an entry, `R` reloads.
--
-- The listing is readonly -- it browses, it does not edit. Create/rename/move
-- with :!mkdir, :!mv or :e <name>, then `R`. Renaming a file that is currently
-- open leaves its buffer on the old path, so follow up with :e <newname>.
--
-- See the netrw NOTE at the top of this file for why netrw must stay disabled.

vim.keymap.set("n", "<leader>fp", '<cmd>let @+ = fnamemodify(expand("%:p"), ":~:.")<CR>', { desc = "Copy path" })

-- Search

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

-- Git

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
	-- Only real file buffers: skips directory listings (nvim.dir sets buftype =
	-- "nowrite"), fzf-lua previews, terminals and
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
		-- Reports loaded/total rather than a bare count: with most plugins deferred,
		-- how few are actually loaded is the interesting number.
		local stats = require("lazy").stats()
		local ms = (vim.uv.hrtime() - start_time) / 1e6
		-- NOTE: scheduled so the echo lands after the intro screen is drawn;
		-- echoing inside VimEnter itself suppresses it.
		vim.schedule(function()
			vim.api.nvim_echo({
				{ "startup took ", "Comment" },
				{ string.format("%.0f ms", ms), "Title" },
				{ string.format("  \u{b7}  %d/%d plugins", stats.loaded, stats.count), "Comment" },
			}, false, {})
		end)
	end,
})
