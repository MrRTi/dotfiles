return {
	{
		-- Set lualine as statusline
		"nvim-lualine/lualine.nvim",
		-- See `:help lualine.txt`
		dependencies = {
			"folke/noice.nvim",
		},
		config = function()
			require("lualine").setup({
				sections = {
					lualine_x = {
						{
							-- require("noice").api.statusline.mode.get,
							-- cond = require("noice").api.statusline.mode.has,
							color = { fg = "#ff9e64" },
						},
					},
				},
				options = {
					icons_enabled = false,
					--[[ theme = 'onedark', ]]
					component_separators = "|",
					section_separators = "",
				},
			})
		end,
	},
}
