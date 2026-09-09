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
-- swapfile is off, so without this undo history dies with the session.
vim.o.undofile = true
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
-- NOTE: no `vim.o.background` here on purpose. The TUI queries the terminal
-- (OSC 11) at startup and sets it from the real background colour, so setting
-- it explicitly would clobber that. See the Appearance section.

vim.o.scrolloff = 999
-- NOTE: horizontal scrolling starts once the cursor passes (text area - sidescrolloff),
-- and from then on every column move repaints the whole window. At 999 the cursor is
-- pinned mid-window, so that point is *half* the text area -- a 62-char line already
-- scrolls in a 130-col terminal, and a vertical split drops it to ~col 36. At 20 the
-- trigger tracks the window edge instead, so ordinary lines never scroll while still
-- keeping 20 columns of lookahead. Costs the horizontal centering `scrolloff = 999`
-- gives vertically.
vim.o.sidescrolloff = 20

-- Built-in LSP completion: fuzzy matching, show menu, don't auto-insert.
-- vim.opt rather than vim.o because this one takes a list.
vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect", "fuzzy" }

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

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("Indent", { clear = true }),
	pattern = vim.tbl_keys(indent_overrides),
	callback = function()
		local opts = indent_overrides[vim.bo.filetype]
		vim.bo.tabstop = opts.tabstop
		vim.bo.shiftwidth = opts.shiftwidth
		vim.bo.softtabstop = opts.softtabstop
		vim.bo.expandtab = opts.expandtab
	end,
})

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
--
-- Every plugin's own config, keymaps and highlight tweaks live inside its spec
-- below -- that co-location is the entire point of being on lazy. Keep it that
-- way; anything that drifts back out here loses the guarantee above.
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
	-- to defer.
	{
		"ellisonleao/gruvbox.nvim",
		name = "gruvbox",
		lazy = false,
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				contrast = "hard",
				transparent_mode = true,
			})
			-- NOTE: a ColorScheme autocmd, not two bare `hi` calls. `transparent_mode`
			-- leaves the float highlights opaque, and toggling 'background' via
			-- <leader>ut re-applies gruvbox -- which used to clobber one-shot
			-- overrides set at startup (NormalFloat guibg went from NONE back to the
			-- light background). Registered before `colorscheme` so the first apply
			-- fires it too.
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("Appearance", { clear = true }),
				pattern = "gruvbox",
				callback = function()
					vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
					vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
				end,
			})
			vim.cmd("colorscheme gruvbox")
		end,
	},
	{
		"echasnovski/mini.statusline",
		lazy = false,
		config = function()
			require("user.statusline").setup()
		end,
	},
	{
		"folke/which-key.nvim",
		lazy = false,
		config = function()
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
		end,
	},
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
	--
	-- NOTE: the keymaps belong here, not in a Git section further down. They are
	-- `<cmd>Gitsigns ...<CR>` strings, so registering them at startup left them
	-- dead until a file was read -- pressing <leader>gb from the intro screen gave
	-- "E492: Not an editor command: Gitsigns blame_line". As `keys` they double as
	-- a load trigger, so the command exists by the time the key is re-fed.
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{ "<leader>gb", "<cmd>Gitsigns blame_line<CR>", mode = { "n", "v" }, desc = "Blame line" },
			{ "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", mode = { "n", "v" }, desc = "Preview hunk" },
			{ "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", mode = { "n", "v" }, desc = "Stage hunk" },
			{ "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", desc = "Stage buffer" },
			{ "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "Undo stage hunk" },
			{ "<leader>gq", "<cmd>Gitsigns setqflist<CR>", desc = "Hunks to quickfix" },
			{ "[h", "<cmd>Gitsigns prev_hunk<CR>", desc = "Previous hunk" },
			{ "]h", "<cmd>Gitsigns next_hunk<CR>", desc = "Next hunk" },
		},
	},
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

-- UI

-- NOTE: 'background' is detected by the TUI, which queries the terminal for its
-- background colour (OSC 11) at startup. Ghostty follows the macOS appearance
-- (theme = dark:...,light:... in its config), so nvim tracks the system theme for
-- free. This replaced an is_dark_local() helper that shelled out to `osascript`:
-- that call blocked startup for ~104 ms, about half of total startup time.
-- Verify with `:echo &background` under both macOS appearances.
-- The float transparency that this toggle would otherwise clobber is re-applied
-- by the ColorScheme autocmd in the gruvbox spec above.
vim.keymap.set("n", "<leader>ut", function()
	vim.o.background = vim.o.background == "light" and "dark" or "light"
end, { desc = "Toggle light/dark" })

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

local lsp_group = vim.api.nvim_create_augroup("Lsp", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.server_capabilities.completionProvider then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
		-- NOTE: gd is not one of the 0.11 built-in LSP defaults (grr/grn/gra/gri/gO
		-- are, see the comment near those below) -- it stays bound to core Vim's
		-- "goto local Declaration", which only searches the current file and no-ops
		-- (or jumps wrong) once the real definition lives elsewhere. Rebind it
		-- buffer-locally to the LSP definition jump instead.
		if client and client.server_capabilities.definitionProvider then
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Goto definition" })
		end
		-- ruff is the sole Python formatter (conform's formatters_by_ft above
		-- intentionally has no python entry, and no black/isort) -- wire its
		-- format-on-save here since it's a plain LSP client.
		--
		-- NOTE: grouped per buffer and cleared, so re-attaching (LSP restart, :e)
		-- replaces the hook instead of stacking another format pass onto the save.
		if client and client.name == "ruff" and client.server_capabilities.documentFormattingProvider then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("LspRuffFormat" .. ev.buf, { clear = true }),
				buffer = ev.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = ev.buf, id = client.id })
				end,
			})
		end
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = lsp_group,
	callback = function()
		for _, client in ipairs(vim.lsp.get_clients()) do
			client:stop()
		end
	end,
})

-- NOTE: grr (references), grn (rename), gra (code action), gri (implementation)
--       are Neovim 0.11 built-ins and appear in which-key automatically. gd is
--       not one of them -- rebound to vim.lsp.buf.definition in the LspAttach
--       autocmd above, since core Vim's own gd only searches the current file.

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

-- NOTE: the Gitsigns maps live in the gitsigns spec above. This one is a plain
-- terminal command with no plugin behind it, so it stays here.
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

-- Buffer

vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Autocmds

require("user.doublewidth").setup()

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	pattern = "*",
	callback = function()
		vim.hl.hl_op({ higroup = "IncSearch", timeout = 200 })
	end,
})

-- Startup report, echoed under the intro screen. Skipped when nvim was given a
-- file (no intro to annotate) or has no UI (--headless).
vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("Startup", { clear = true }),
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
