return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = true, -- disables setting the background color.
				integrations = {
					gitsigns = true,
					harpoon = true,
					mason = true,
					cmp = true,
					lsp_trouble = true,
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
							information = { "italic" },
						},
						underlines = {
							errors = { "underline" },
							hints = { "underline" },
							warnings = { "underline" },
							information = { "underline" },
						},
						inlay_hints = {
							background = true,
						},
					},
					treesitter = true,
					treesitter_context = false,
					telescope = {
						enabled = true,
					},
					which_key = true,
				},
			})
			-- vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"yorik1984/newpaper.nvim",
		-- priority = 1000,
		config = function()
			require("newpaper").setup({
				disable_background = true,
			})
		end,
	},
	{
		"cormacrelf/dark-notify",
		config = function()
			require("dark_notify").run({
				schemes = {
					dark = {
						background = "dark",
					},
					light = {
						background = "light",
					},
				},
				onchange = function(mode)
					-- mode is either "light" or "dark"
					if mode == "light" then
						require("newpaper").setup({
							style = "light",
						})
						require("lualine").setup({
							options = {
								theme = "newpaper-light",
							},
						})
					else
						require("newpaper").setup({
							style = "dark",
						})
						require("lualine").setup({
							options = {
								theme = "newpaper-dark",
							},
						})
					end

					vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
					vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
				end,
			})
		end,
	},
	{
		-- Set lualine as statusline
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
					-- Theme changed by dark_notify
					-- theme = "newpaper-dark",
					theme = "newpaper-light",
					-- empty with newpaper colorscheme
					section_separators = { "", "" },
					component_separators = { "│", "│" },
				},
				sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {
						{
							"filename",
							newfile_status = false,
							path = 1,
							shorting_target = 80,
							padding = {
								left = 0,
								right = 1,
							},
						},
					},
					lualine_x = {
						"branch",
						"diff",
						"diagnostics",
						"location",
						{
							"progress",
							padding = {
								left = 1,
								right = 0,
							},
						},
					},
					lualine_y = {},
					lualine_z = {},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {
						{
							"filename",
							path = 1,
						},
					},
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				winbar = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
}
