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
  python     = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true },
  go         = { tabstop = 8, shiftwidth = 8, softtabstop = 0, expandtab = false }, -- tabs, no expand
  make       = { tabstop = 8, shiftwidth = 8, softtabstop = 0, expandtab = false }, -- tabs, no expand
  dockerfile = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true },
  ["*"]      = { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true },  -- default: 2 spaces
}

for fyletype, opts in pairs(indent_settings) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = fyletype,
    callback = function()
      vim.bo.tabstop     = opts.tabstop
      vim.bo.shiftwidth  = opts.shiftwidth
      vim.bo.softtabstop = opts.softtabstop
      vim.bo.expandtab   = opts.expandtab
    end,
  })
end

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
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
})

vim.lsp.enable({
  "lua_ls",
  "ruby_lsp",
  "pyright",
  "yamlls",
  "marksman",
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }
      }
    }
  }
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
    "javascript",
    "yaml",
    "json",
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

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    ruby = { "rubocop" },
    sh = { "shfmt" },
    zsh = { "shfmt" },
    markdown = { "prettier" },
  },
})

vim.keymap.set('n', '<leader>bd', ':bdelete<CR>')

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')

vim.keymap.set('n', '<leader><space>', ":FzfLua global<CR>")
vim.keymap.set('n', '<leader>sf', ":FzfLua files<CR>")
vim.keymap.set('n', '<leader>sw', ":FzfLua grep_cword<CR>")
vim.keymap.set('n', '<leader>sg', ":FzfLua live_grep<CR>")
vim.keymap.set('n', '<leader>sh', ":FzfLua helptags<CR>")
vim.keymap.set('n', '<leader>sr', ":FzfLua resume<CR>")

vim.keymap.set('n', '<leader>e', ":Oil<CR>")
vim.keymap.set('n', '<leader>-', ":Oil<CR>")

vim.keymap.set('n', '<leader>fp', '<cmd>let @+ = expand("%")<CR>', { desc = "Copy file path to clipboard" })

vim.keymap.set('n', '<leader>gg', ":LazyGit<CR>")
vim.keymap.set({ 'n', 'v' }, '<leader>gb', ":Gitsigns blame_line<CR>")
vim.keymap.set({ 'n', 'v' }, '<leader>gp', ":Gitsigns preview_hunk_inline<CR>")
vim.keymap.set('n', '[h', ":Gitsigns prev_hunk<CR>")
vim.keymap.set('n', ']h', ":Gitsigns next_hunk<CR>")

-- vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set({ 'n', 'v' }, '<leader>lf', function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file or selection" })
vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)

vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, { desc = "Open floating diagnostic window" })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)


local harpoon = require("harpoon")
harpoon.setup()
vim.keymap.set("n", "<leader>H", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "[H", function() harpoon:list():prev() end)
vim.keymap.set("n", "]H", function() harpoon:list():next() end)


vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank {
      higroup = "IncSearch",
      timeout = 200,
    }
  end,
})

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

require('tokyonight').setup({
  transparent = true,
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
})
vim.cmd("colorscheme tokyonight")
vim.cmd(":hi statusline guibg=NONE")
