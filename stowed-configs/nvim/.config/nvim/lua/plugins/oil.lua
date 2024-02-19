return {
	{
		"stevearc/oil.nvim",
		opts = {},
		-- Optional dependencies
		config = function()
			require("oil").setup({
				columns = {
					-- "icon",
					-- "permissions",
					-- "size",
					-- "mtime",
				},
				view_options = {
					-- Show files and directories that start with "."
					show_hidden = true,
				},
			})
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
			vim.keymap.set("n", "<leader>pf", "<CMD>Oil<CR>", { desc = "[p]roject [f]iles" })
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
}
