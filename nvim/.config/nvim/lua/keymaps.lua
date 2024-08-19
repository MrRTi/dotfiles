-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Functional wrapper for mapping custom keybindings
local function add_keymap(mode, lhs, rhs, opts)
	vim.keymap.set(mode, lhs, rhs, opts)
end

local function add_keymap_with_desc(mode, lhs, rhs, desc)
	add_keymap(mode, lhs, rhs, { desc = desc })
end

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
add_keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
add_keymap_with_desc("n", "<leader>q", vim.diagnostic.setloclist, "Open diagnostic [Q]uickfix list")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
add_keymap_with_desc("t", "<Esc><Esc>", "<C-\\><C-n>", "Exit terminal mode")

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
add_keymap_with_desc("n", "<C-h>", "<C-w><C-h>", "Move focus to the left window")
add_keymap_with_desc("n", "<C-l>", "<C-w><C-l>", "Move focus to the right window")
add_keymap_with_desc("n", "<C-j>", "<C-w><C-j>", "Move focus to the lower window")
add_keymap_with_desc("n", "<C-k>", "<C-w><C-k>", "Move focus to the upper window")

-- Open netrw
add_keymap_with_desc("n", "-", vim.cmd.Ex, "Open netrw (directory)")
add_keymap_with_desc("n", "<leader>fx", "<cmd>! chmod +x %<CR>", "make [F]ile executable")
-- Place current file path in clipboard
add_keymap_with_desc("n", "<leader>fp", '<cmd>let @+ = expand("%")<CR>', "copy [F]ile [P]ath")

-- Keep cursor in the middle when half-page jump
add_keymap("n", "<C-d>", "<C-d>zz")
add_keymap("n", "<C-u>", "<C-u>zz")

-- Keep cursor in the middle when scrolling
add_keymap("n", "j", "jzz")
add_keymap("n", "k", "kzz")
add_keymap("n", "G", "Gzz")

-- Keep cursor in the middle while search
add_keymap("n", "n", "nzzzv")
add_keymap("n", "N", "Nzzzv")

-- Paste in visual mode and keep pasted in buffer
add_keymap_with_desc("x", "<leader>p", [["_dP]], "[P]aste in visial mode and keep pasted in buffer")

-- Use system clipboard
add_keymap_with_desc({ "n", "v" }, "<leader>y", [["+y]], "[Y]ank to system clipboard")
add_keymap_with_desc("n", "<leader>Y", [["+Y]], "[Y]ank line to system clipboard")

-- Delete with void buffer
add_keymap_with_desc({ "n", "v" }, "<leader>d", [["_d]], "[D]elete without yank")

-- Copy Ecs behaviour for C-c
add_keymap("i", "<C-c>", "<Esc>")

-- Remap for dealing with word wrap
add_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
add_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move highlighted text
add_keymap_with_desc("v", "J", ":m '>+1<CR>gv=gv", "[J] Move highlighted text up")
add_keymap_with_desc("v", "K", ":m '<-2<CR>gv=gv", "[K] Move highlighted text down")

-- Function to toggle background color
function ToggleBackground()
	local current_bg = vim.o.background
	if current_bg == "dark" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
end

add_keymap(
	"n",
	"<leader>tt",
	":lua ToggleBackground()<CR>",
	{ noremap = true, silent = true, desc = "[T]oggle [T]heme" }
)

-- vim: ts=2 sts=2 sw=2 et
