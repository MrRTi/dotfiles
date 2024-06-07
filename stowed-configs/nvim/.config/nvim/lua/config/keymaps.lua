-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local add_keymap = vim.keymap.set

add_keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Keymaps for better default experience
-- See `:help add_keymap()`

-- Open netrw
add_keymap("n", "<leader>ff", vim.cmd.Ex, { desc = "[f]iles" })
add_keymap("n", "<leader>fx", "<cmd>! chmod +x %<CR>", { desc = "make [f]ile executable" })
-- Place current file path in clipboard
add_keymap("n", "<leader>fp", '<cmd>let @+ = expand("%")<CR>', { desc = "copy [f]ile [p]ath" })

-- Move highlighted text
add_keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "[J] Move highlighted text up" })
add_keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "[K] Move highlighted text down" })

-- Keep cursor in the middle when half-page jump
add_keymap("n", "<C-d>", "<C-d>zz")
add_keymap("n", "<C-u>", "<C-u>zz")

add_keymap("n", "j", "jzz")
add_keymap("n", "k", "kzz")
add_keymap("n", "G", "Gzz")

-- Add new lines without insert mode
add_keymap(
	"n",
	"<leader>o",
	':<C-u>call append(line("."),   repeat([""], v:count1))<CR>',
	{ desc = "Add new line below" }
)

add_keymap(
	"n",
	"<leader>O",
	':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>',
	{ desc = "Add new line above" }
)

-- Keep cursor in the middle while search
add_keymap("n", "n", "nzzzv")
add_keymap("n", "N", "Nzzzv")

-- Paste in visual mode and keep pasted in buffer
add_keymap("x", "<leader>p", [["_dP]], { desc = "[p]aste in visial mode and keep pasted in buffer" })

-- Use system clipboard
add_keymap({ "n", "v" }, "<leader>y", [["+y]], { desc = "[y]ank to system clipboard" })
add_keymap("n", "<leader>Y", [["+Y]], { desc = "[Y]ank line to system clipboard" })

-- Delete with void buffer
add_keymap({ "n", "v" }, "<leader>d", [["_d]], { desc = "[d]elete without yank" })

-- Copy Ecs behaviour for C-c
add_keymap("i", "<C-c>", "<Esc>")

-- No ex mode
add_keymap("n", "Q", "<nop>")

add_keymap("n", "<C-k>", "<cmd>cnext<CR>zz")
add_keymap("n", "<C-j>", "<cmd>cprevious<CR>zz")
add_keymap("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "next location" })
add_keymap("n", "<leader>j", "<cmd>lprevious<CR>zz", { desc = "prev location" })

-- Remap for dealing with word wrap
add_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
add_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Close buffer
add_keymap("n", "<leader>bd", "<cmd>bd<CR>", { desc = "[b]uffer [d]elete" })

-- Buffer navigation
add_keymap("n", "<leader>b]", "<cmd>bnext<CR>", { desc = '[b]uffer ["]"] next' })
add_keymap("n", "<leader>b[", "<cmd>bprevious<CR>", { desc = '[b]uffer ["["] previous' })
add_keymap("n", "<leader>bl", "<cmd>bnext<CR>", { desc = "[b]uffer [l] next" })
add_keymap("n", "<leader>bh", "<cmd>bprevious<CR>", { desc = "[b]uffer [h] previous" })

-- Diagnostic keymaps
add_keymap("n", "d[", vim.diagnostic.goto_prev, { desc = 'Go to [d]iagnostic message ["["] previous' })
add_keymap("n", "d]", vim.diagnostic.goto_next, { desc = 'Go to [d]iagnostic message ["]"] next' })
add_keymap("n", "<leader>dm", vim.diagnostic.open_float, { desc = "Open floating [d]iagnostic [m]essage" })
add_keymap("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Open [d]iagnostics [l]ist" })

-- Replace current word
add_keymap("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "[r]eplace [w]ord" })

-- Visual Maps
add_keymap("v", "<leader>rw", '"hy:%s/<C-r>h//gc<left><left>', { desc = "Replace all instances of highlighted words" })
add_keymap("v", "<leader>s", ":sort<CR>", { desc = "Sort highlighted text in visual mode with Control+S" })
add_keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move current line down" })
add_keymap("v", "K", ":m '>-2<CR>gv=gv", { desc = "Move current line up" })
