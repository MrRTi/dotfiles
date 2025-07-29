vim.o.number = true
vim.o.relativenumber = false
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"

vim.o.langmap =
"ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

vim.pack.add({
	-- { src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/echasnovski/mini.ai" },
	{ src = "https://github.com/echasnovski/mini.splitjoin" },
	{ src = "https://github.com/echasnovski/mini.extra" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/christoomey/vim-tmux-navigator" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
})

vim.lsp.enable({
	"lua_ls",
	"ruby_lsp",
	"pyright"
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

vim.cmd("set completeopt+=noselect")

require('nvim-treesitter.configs').setup({
	ensure_installed = {
		"lua",
		"ruby",
		"python",
		"javascript"
	},
	highlight = { enable = true }
})

require('mini.pick').setup()
require('mini.ai').setup()
require('mini.splitjoin').setup()

require('oil').setup({
	view_options = {
		show_hidden = true,
	}
})

vim.keymap.set('n', '<leader>cf', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR')
vim.keymap.set('n', '<leader>q', ':quit<CR>')

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')

vim.keymap.set('n', '<leader> ', ":Pick buffers<CR>")
vim.keymap.set('n', '<leader>sf', ":Pick files<CR>")
vim.keymap.set('n', '<leader>sg', ":Pick grep_live<CR>")
vim.keymap.set('n', '<leader>sh', ":Pick help<CR>")
vim.keymap.set('n', '<leader>sr', ":Pick resume<CR>")
vim.keymap.set('n', '<leader>e', ":Oil<CR>")
vim.keymap.set('n', '<leader>fp', '<cmd>let @+ = expand("%")<CR>', { desc = "Copy file path to clipboard" })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

vim.keymap.set('n', '<leader>gg', ":LazyGit<CR>")

vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', '<space>lr', vim.lsp.buf.rename, opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

-- require "vague".setup({ transparent = true })
-- vim.cmd("colorscheme vague")
require('tokyonight').setup({
	transparent = true,
	styles = {
		sidebars = "transparent",
		floats = "transparent",
	},
})
vim.cmd("colorscheme tokyonight")
vim.cmd(":hi statusline guibg=NONE")
