-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

-- Example:
-- map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

map({ "n" }, "<leader>fp", '<cmd>let @+ = expand("%")<CR>', { desc = "Copy file path to clipboard" })
map({ "n" }, "-", '<cmd>Oil<CR>', { desc = "Open Oil" })

