vim.o.number = true
vim.o.relativenumber = false
vim.o.signcolumn = "yes"

vim.o.termguicolors = true
vim.o.wrap = false
vim.o.swapfile = false

vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"

vim.opt.scrolloff = 999
vim.opt.sidescrolloff = 999

vim.opt.cursorline = true

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

-- Add abbility to use йцукен letters same as qwerty. (symbols like :, $ etc won't work as expected)
vim.o.langmap =
    "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ," ..
    "фисвуапршолдьтщзйкыегмцчня;" ..
    "abcdefghijklmnopqrstuvwxyz,"

vim.pack.add({
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
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  {
    src = "https://github.com/ThePrimeagen/harpoon",
    version = "harpoon2"
  },
  { src = "https://github.com/nvimtools/none-ls.nvim" },
  { src = "https://github.com/nvim-neotest/neotest" },
  -- deps
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/antoinemadec/FixCursorHold.nvim" },
  { src = "https://github.com/olimorris/neotest-rspec" },
  --
  { src = "https://github.com/andythigpen/nvim-coverage" },
  -- Theme
  { src = "https://github.com/catppuccin/nvim" },
})

require("todo-comments").setup()
require('mini.ai').setup()
require('mini.completion').setup()
require('mini.extra').setup()
require('mini.splitjoin').setup()
require("coverage").setup({
  auto_reload = true,
})
require("neotest").setup({
  adapters = {
    require("neotest-rspec")
  },
})

vim.lsp.enable({
  "lua_ls",
  "ruby_lsp",
  "pyright",
  "ruff",
  "yamlls",
  "marksman",
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      }
    }
  }
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.server_capabilities.completionProvider then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.opt.completeopt:append("noselect")


local null_ls = require("null-ls")
local augroup_format = vim.api.nvim_create_augroup("NullLsFormat", { clear = true })

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.completion.spell,
    -- Python
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.diagnostics.flake8,
    -- Ruby
    null_ls.builtins.formatting.rubocop,
    null_ls.builtins.diagnostics.rubocop,
    -- Docker
    -- null_ls.builtins.formatting.dockerfile_lint,
    -- JSON
    null_ls.builtins.formatting.jq,
    -- YAML
    null_ls.builtins.formatting.yamlfmt,
    -- Shell
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.diagnostics.shellcheck,
  },
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup_format,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})

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


vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = "Delete buffer" })

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d', { desc = "Delete to system clipboard" })

vim.keymap.set('n', '<leader><space>', '<cmd>FzfLua<CR>', { desc = "Open FzfLua picker" })
vim.keymap.set('n', '<leader>sf', '<cmd>FzfLua files<CR>', { desc = "Search files" })
vim.keymap.set('n', '<leader>sw', '<cmd>FzfLua grep_cword<CR>', { desc = "Search word under cursor" })
vim.keymap.set('n', '<leader>sg', '<cmd>FzfLua live_grep<CR>', { desc = "Live grep" })
vim.keymap.set('n', '<leader>sh', '<cmd>FzfLua helptags<CR>', { desc = "Search help tags" })
vim.keymap.set('n', '<leader>sr', '<cmd>FzfLua resume<CR>', { desc = "Resume last search" })

vim.keymap.set('n', '<leader>e', '<cmd>Oil<CR>', { desc = "Open file explorer" })
vim.keymap.set('n', '<leader>-', '<cmd>Oil<CR>', { desc = "Open file explorer" })

vim.keymap.set('n', '<leader>fp', '<cmd>let @+ = expand("%")<CR>', { desc = "Copy file path to clipboard" })

vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<CR>', { desc = "Open LazyGit" })
vim.keymap.set({ 'n', 'v' }, '<leader>gb', '<cmd>Gitsigns blame_line<CR>', { desc = "Git blame line" })
vim.keymap.set({ 'n', 'v' }, '<leader>gp', '<cmd>Gitsigns preview_hunk_inline<CR>', { desc = "Preview hunk inline" })
vim.keymap.set('n', '[h', '<cmd>Gitsigns prev_hunk<CR>', { desc = "Previous git hunk" })
vim.keymap.set('n', ']h', '<cmd>Gitsigns next_hunk<CR>', { desc = "Next git hunk" })

vim.keymap.set({ 'n', 'v' }, '<leader>lf', function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format file or selection" })

vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = "LSP rename" })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "Go to references" })

vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, { desc = "Open floating diagnostic window" })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next diagnostic" })


local harpoon = require("harpoon")
harpoon.setup()

vim.keymap.set("n", "<leader>H", function()
  harpoon:list():add()
end, { desc = "Add file to harpoon" })

vim.keymap.set("n", "<leader>h", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Toggle harpoon menu" })

vim.keymap.set("n", "[H", function()
  harpoon:list():prev()
end, { desc = "Previous harpoon file" })

vim.keymap.set("n", "]H", function()
  harpoon:list():next()
end, { desc = "Next harpoon file" })


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

local function is_dark_local()
  local handle = io.popen(
    [[osascript -e 'tell application "System Events" to tell appearance preferences to get dark mode']])
  if not handle then return false end
  local result = handle:read("*a")
  handle:close()
  result = result:lower():gsub("%s+", "")
  return result == "true"
end

local function is_dark_term()
  return print(is_dark_local())
end

require("catppuccin").setup({
  transparent_background = true
})

vim.cmd("colorscheme catppuccin")

local function toggle_appearance(toggle_to)
  toggle_to = toggle_to or (vim.o.background == "light" and "dark" or "light")
  if toggle_to == "light" then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end
end

if is_dark_local() then
  toggle_appearance("dark")
else
  toggle_appearance("light")
end

vim.keymap.set('n', '<leader>tt', toggle_appearance, { desc = "Toggle light/dark appearance" })

vim.cmd("hi statusline guibg=NONE")
