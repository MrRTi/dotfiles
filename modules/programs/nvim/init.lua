vim.o.number = true
vim.o.relativenumber = false
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"

local indent_settings = {
  python     = { ts = 4, sw = 4, sts = 4, et = true },
  go         = { ts = 8, sw = 8, sts = 0, et = false }, -- tabs, no expand
  dockerfile = { ts = 4, sw = 4, sts = 4, et = true },
  ["*"]      = { ts = 2, sw = 2, sts = 2, et = true },  -- default: 2 spaces
}

-- Set specific filetypes
for ft, opts in pairs(indent_settings) do
  if ft ~= "*" then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = ft,
      callback = function()
        vim.bo.tabstop     = opts.ts
        vim.bo.shiftwidth  = opts.sw
        vim.bo.softtabstop = opts.sts
        vim.bo.expandtab   = opts.et
      end,
    })
  end
end

-- Fallback for all other filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    local opts = indent_settings["*"]
    vim.bo.tabstop     = opts.ts
    vim.bo.shiftwidth  = opts.sw
    vim.bo.softtabstop = opts.sts
    vim.bo.expandtab   = opts.et
  end,
})

vim.o.langmap =
"ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/echasnovski/mini.ai" },
	{ src = "https://github.com/echasnovski/mini.splitjoin" },
	{ src = "https://github.com/echasnovski/mini.extra" },
	{ src = "https://github.com/echasnovski/mini.completion" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/christoomey/vim-tmux-navigator" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
})

vim.lsp.enable({
	"lua_ls",
	"ruby_lsp",
	"pyright",
	"yamlls",
	"nixd",
	"marksman",
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

-- vim.cmd("set completeopt+=noselect")

require('nvim-treesitter.configs').setup({
	ensure_installed = {
		"lua",
		"ruby",
		"python",
		"javascript",
		"yaml",
		"json",
		"nix"
	},
	highlight = { enable = true }
})

require('mini.ai').setup()
require('mini.splitjoin').setup()
require('mini.extra').setup()
require('mini.completion').setup()

require('oil').setup({
	view_options = {
		show_hidden = true,
	}
})

require('fzf-lua').setup({
	winopts = {
		preview = {
			layout = "vertical",
		}
	},
	keymap = {
		fzf = {
			true,
			-- Use <c-q> to select all items and add them to the quickfix list
			["ctrl-q"] = "select-all+accept",
		},
	},
})

vim.keymap.set('n', '<leader>cf', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR')
vim.keymap.set('n', '<leader>q', ':quit<CR>')

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')

vim.keymap.set('n', '<leader><space>', ":FzfLua global<CR>")
vim.keymap.set('n', '<leader>sf', ":FzfLua files<CR>")
vim.keymap.set('n', '<leader>sg', ":FzfLua live_grep<CR>")
vim.keymap.set('n', '<leader>sh', ":FzfLua helptags<CR>")
vim.keymap.set('n', '<leader>sr', ":FzfLua resume<CR>")
vim.keymap.set('n', '<leader>e', ":Oil<CR>")
vim.keymap.set('n', '<leader>fp', '<cmd>let @+ = expand("%")<CR>', { desc = "Copy file path to clipboard" })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

vim.keymap.set('n', '<leader>gg', ":LazyGit<CR>")

vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

require('tokyonight').setup({
	transparent = true,
	styles = {
		sidebars = "transparent",
		floats = "transparent",
	},
})
vim.cmd("colorscheme tokyonight")
vim.cmd(":hi statusline guibg=NONE")

-- Function to toggle background color
vim.o.background = "dark"

function ToggleBackground()
	local current_bg = vim.o.background
	if current_bg == "dark" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
end

vim.keymap.set('n', '<leader>tt', ToggleBackground)
