-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Functional wrapper for mapping custom keybindings
local function add_keymap(mode, lhs, rhs, opts)
	vim.keymap.set(mode, lhs, rhs, opts)
end

local function add_keymap_with_desc(mode, lhs, rhs, desc)
	add_keymap(mode, lhs, rhs, { desc = desc })
end

add_keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Open netrw
add_keymap_with_desc("n", "<leader>ff", vim.cmd.Ex, "[f]iles")
add_keymap_with_desc("n", "<leader>fx", "<cmd>! chmod +x %<CR>", "make [f]ile executable")
-- Place current file path in clipboard
add_keymap_with_desc("n", "<leader>fp", '<cmd>let @+ = expand("%")<CR>', "copy [f]ile [p]ath")

-- Move highlighted text
add_keymap_with_desc("v", "J", ":m '>+1<CR>gv=gv", "[J] Move highlighted text up")
add_keymap_with_desc("v", "K", ":m '<-2<CR>gv=gv", "[K] Move highlighted text down")

-- Keep cursor in the middle when half-page jump
add_keymap("n", "<C-d>", "<C-d>zz")
add_keymap("n", "<C-u>", "<C-u>zz")

add_keymap("n", "j", "jzz")
add_keymap("n", "k", "kzz")
add_keymap("n", "G", "Gzz")

-- Add new lines without insert mode
add_keymap_with_desc(
	"n",
	"<leader>o",
	':<C-u>call append(line("."), repeat([""], v:count1))<CR>',
	"Add new line below"
)

add_keymap_with_desc(
	"n",
	"<leader>O",
	':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>',
	"Add new line above"
)

-- Keep cursor in the middle while search
add_keymap("n", "n", "nzzzv")
add_keymap("n", "N", "Nzzzv")

-- Paste in visual mode and keep pasted in buffer
add_keymap_with_desc("x", "<leader>p", [["_dP]], "[p]aste in visial mode and keep pasted in buffer")

-- Use system clipboard
add_keymap_with_desc({ "n", "v" }, "<leader>y", [["+y]], "[y]ank to system clipboard")
add_keymap_with_desc("n", "<leader>Y", [["+Y]], "[Y]ank line to system clipboard")

-- Delete with void buffer
add_keymap_with_desc({ "n", "v" }, "<leader>d", [["_d]], "[d]elete without yank")

-- Copy Ecs behaviour for C-c
add_keymap("i", "<C-c>", "<Esc>")

-- No ex mode
add_keymap("n", "Q", "<nop>")

add_keymap("n", "<C-k>", "<cmd>cnext<CR>zz")
add_keymap("n", "<C-j>", "<cmd>cprevious<CR>zz")
add_keymap_with_desc("n", "<leader>k", "<cmd>lnext<CR>zz", "next location")
add_keymap_with_desc("n", "<leader>j", "<cmd>lprevious<CR>zz", "prev location")

-- Remap for dealing with word wrap
add_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
add_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Close buffer
add_keymap_with_desc("n", "<leader>bd", "<cmd>bd<CR>", "[b]uffer [d]elete")

-- Buffer navigation
add_keymap_with_desc("n", "<leader>b]", "<cmd>bnext<CR>", '[b]uffer ["]"] next')
add_keymap_with_desc("n", "<leader>b[", "<cmd>bprevious<CR>", '[b]uffer ["["] previous')
add_keymap_with_desc("n", "<leader>bl", "<cmd>bnext<CR>", "[b]uffer [l] next")
add_keymap_with_desc("n", "<leader>bh", "<cmd>bprevious<CR>", "[b]uffer [h] previous")

-- Diagnostic keymaps
add_keymap_with_desc("n", "d[", vim.diagnostic.goto_prev, 'Go to [d]iagnostic message ["["] previous')
add_keymap_with_desc("n", "d]", vim.diagnostic.goto_next, 'Go to [d]iagnostic message ["]"] next')
add_keymap_with_desc("n", "<leader>dm", vim.diagnostic.open_float, "Open floating [d]iagnostic [m]essage")
add_keymap_with_desc("n", "<leader>dl", vim.diagnostic.setloclist, "Open [d]iagnostics [l]ist")

-- Replace current word
add_keymap_with_desc("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "[r]eplace [w]ord")

-- Visual Maps
add_keymap_with_desc("v", "<leader>rw", '"hy:%s/<C-r>h//gc<left><left>', "Replace all instances of highlighted words")
add_keymap_with_desc("v", "<leader>s", ":sort<CR>", "Sort highlighted text in visual mode with Control+S")
add_keymap_with_desc("v", "J", ":m '>+1<CR>gv=gv", "Move current line down")
add_keymap_with_desc("v", "K", ":m '>-2<CR>gv=gv", "Move current line up")
