return {
	{ -- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = "ibl",
		opts = {
			indent = {
				char = "┊",
			},
			whitespace = {
				remove_blankline_trail = false,
			},
		},
	},
}
-- vim: ts=2 sts=2 sw=2 et
