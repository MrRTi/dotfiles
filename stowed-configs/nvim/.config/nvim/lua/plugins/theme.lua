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
					else
						require("newpaper").setup({
							style = "dark",
						})
					end

					vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
					vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
				end,
			})
		end,
	},
}
