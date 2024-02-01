-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

-- Open netrw
vim.keymap.set("n", "<leader>pf", vim.cmd.Ex, { desc = "[p]roject [f]iles" })

-- Move highlighted text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "[J] Move highlighted text up" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "[K] Move highlighted text down" })

-- Keep cursor in the middle when half-page jump
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "j", "jzz")
vim.keymap.set("n", "k", "kzz")
vim.keymap.set("n", "G", "Gzz")

-- Add new lines without insert mode
vim.keymap.set(
	"n",
	"<leader>o",
	':<C-u>call append(line("."),   repeat([""], v:count1))<CR>',
	{ desc = "Add new line below" }
)

vim.keymap.set(
	"n",
	"<leader>O",
	':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>',
	{ desc = "Add new line above" }
)

-- Keep cursor in the middle while search
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste in visual mode and keep pasted in buffer
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "[p]aste in visial mode and keep pasted in buffer" })

-- Use system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[y]ank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "[Y]ank line to system clipboard" })

-- Delete with void buffer
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "[d]elete without yank" })

-- Copy Ecs behaviour for C-c
vim.keymap.set("i", "<C-c>", "<Esc>")

-- No ex mode
vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprevious<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "next location" })
vim.keymap.set("n", "<leader>j", "<cmd>lprevious<CR>zz", { desc = "prev location" })

-- Replace current word
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "[r]eplace [w]ord" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Close buffer
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "[b]uffer [d]elete" })

-- Buffer navigation
vim.keymap.set("n", "<leader>b]", "<cmd>bnext<CR>", { desc = '[b]uffer ["]"] next' })
vim.keymap.set("n", "<leader>b[", "<cmd>bprevious<CR>", { desc = '[b]uffer ["["] previous' })
vim.keymap.set("n", "<leader>bl", "<cmd>bnext<CR>", { desc = "[b]uffer [l] next" })
vim.keymap.set("n", "<leader>bh", "<cmd>bprevious<CR>", { desc = "[b]uffer [h] previous" })

-- Place current file path in clipboard
vim.keymap.set("n", "<leader>fp", '<cmd>let @+ = expand("%")<CR>', { desc = "[f]ile [p]ath" })

-- Diagnostic keymaps
vim.keymap.set("n", "d[", vim.diagnostic.goto_prev, { desc = 'Go to [d]iagnostic message ["["] previous' })
vim.keymap.set("n", "d]", vim.diagnostic.goto_next, { desc = 'Go to [d]iagnostic message ["]"] next' })
vim.keymap.set("n", "<leader>dm", vim.diagnostic.open_float, { desc = "Open floating [d]iagnostic [m]essage" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Open [d]iagnostics [l]ist" })
