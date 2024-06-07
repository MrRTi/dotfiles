return {
	-- Git related plugins
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gg", ":Git<CR>", { desc = "[g]it fugitive" })
		end,
	},
	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				vim.keymap.set(
					"n",
					"<leader>ghp",
					require("gitsigns").preview_hunk,
					{ buffer = bufnr, desc = "[g]it [h]unk [p]review" }
				)
				vim.keymap.set(
					"n",
					"<leader>gb",
					require("gitsigns").toggle_current_line_blame,
					{ buffer = bufnr, desc = "[g]it [b]lame" }
				)

				-- don't override the built-in and fugitive keymaps
				local gs = package.loaded.gitsigns
				vim.keymap.set({ "n", "v" }, "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
				vim.keymap.set({ "n", "v" }, "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
			end,
		},
	},
	-- Working with git worktrees in nvim
	{
		"ThePrimeagen/git-worktree.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{
				"<leader>gwa",
				"<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
				desc = "[g]it [w]orktree [a]dd",
			},
			{
				"<leader>gws",
				"<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
				desc = "[g]it [w]orktree [s]witch",
			},
		},
	},
}
