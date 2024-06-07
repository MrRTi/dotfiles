return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },

		config = function()
			local harpoon = require("harpoon")

			-- REQUIRED
			harpoon:setup({})

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-S-P>", function()
				harpoon:list():prev()
			end)
			vim.keymap.set("n", "<C-S-N>", function()
				harpoon:list():next()
			end)

			vim.keymap.set("n", "<leader>ha", function()
				harpoon:list():add()
			end, { desc = "[h]arpoon [a]dd" })

			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end

			local toggle_opts = {
				border = "rounded",
				title_pos = "center",
				ui_width_ratio = 0.80,
			}

			vim.keymap.set("n", "<leader>hm", function()
				harpoon.ui:toggle_quick_menu(harpoon:list(), toggle_opts)
			end, { desc = "[h]arpoon quick [m]enu (original)" })

			vim.keymap.set("n", "<leader>hq", function()
				toggle_telescope(harpoon:list())
			end, { desc = "[h]arpoon [q]uick menu (telescope)" })

			vim.keymap.set("n", "<leader>h]", function()
				harpoon:list():next()
			end, { desc = '[h]arpoon ["["] (next)' })

			vim.keymap.set("n", "<leader>h[", function()
				harpoon:list():prev()
			end, { desc = '[h]arpoon ["]"] (prev)' })

			vim.keymap.set("n", "<leader>hl", function()
				harpoon:list():next()
			end, { desc = "[h]arpoon [l] (next)" })

			vim.keymap.set("n", "<leader>hh", function()
				harpoon:list():prev()
			end, { desc = "[h]arpoon [h] (prev)" })

			-- basic telescope configuration
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end

			vim.keymap.set("n", "<leader>ht", function()
				toggle_telescope(harpoon:list())
			end, { desc = "[h]arpoon [t]elescope" })
		end,
	},
}
