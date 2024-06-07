return {
	-- Fuzzy Finder (files, lsp, etc)
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				-- NOTE: If you are having trouble with this installation,
				--       refer to the README for telescope-fzf-native for more instructions.
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
				config = function()
					-- Enable telescope fzf native, if installed
					pcall(require("telescope").load_extension, "fzf")
				end,
			},
		},
		keys = {
			-- See `:help telescope.builtin`
			{
				"<leader>?",
				require("telescope.builtin").oldfiles,
				desc = "[?] Find recently opened files",
			},
			{
				"<leader><space>",
				require("telescope.builtin").buffers,
				desc = "[ ] Find existing buffers",
			},
			{
				"<leader>/",
				function()
					require("telescope.builtin").current_buffer_fuzzy_find({ previewer = false })
				end,
				desc = "[/] Fuzzily search in current buffer",
			},

			{
				"<leader>sg",
				require("telescope.builtin").git_files,
				desc = "[s]earch [g]it files",
			},
			{
				"<leader>sf",
				require("telescope.builtin").find_files,
				desc = "[s]earch [f]iles",
			},
			{
				"<leader>s?",
				require("telescope.builtin").help_tags,
				desc = "[s]earch [?] help",
			},
			{
				"<leader>sw",
				require("telescope.builtin").grep_string,
				desc = "[s]earch current [w]ord",
			},
			{
				"<leader>ss",
				require("telescope.builtin").live_grep,
				desc = "[s]earch by grep",
			},
			{
				"<leader>sd",
				require("telescope.builtin").diagnostics,
				desc = "[s]earch [d]iagnostics",
			},

			{
				"<leader>sc",
				require("telescope.builtin").commands,
				desc = "[s]earch [c]ommands",
			},

			-- Marks
			{
				"<leader>ms",
				require("telescope.builtin").marks,
				desc = "[m]arks [s]earch",
			},

			-- Quickfix
			{
				"<leader>qs",
				require("telescope.builtin").quickfix,
				desc = "[q]uickfix [s]earch",
			},

			{
				"<leader>qh",
				require("telescope.builtin").quickfixhistory,
				desc = "[q]uickfix [h]istory",
			},

			-- Git
			{
				"<leader>gs",
				require("telescope.builtin").git_status,
				desc = "[g]it [s]status",
			},
			{
				"<leader>gc",
				require("telescope.builtin").git_commits,
				desc = "[g]it [c]ommits",
			},

			{
				"<leader>sr",
				require("telescope.builtin").resume,
				desc = "[s]earch [r]esume",
			},
			{
				"<leader>sh",
				require("telescope.builtin").search_history,
				desc = "[s]earch [h]istory",
			},
		},
		opts = function()
			-- See `:help telescope` and `:help telescope.setup()`
			return {
				defaults = require("telescope.themes").get_ivy({
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-d>"] = false,
						},
					},
				}),
				pickers = {
					find_files = {
						find_command = {
							"rg",
							"--no-ignore",
							"--hidden",
							"--files",
							"-g",
							"!**/node_modules/*",
							"-g",
							"!**/.git/*",
						},
					},
					grep_string = {
						additional_args = function()
							return { "--hidden" }
						end,
					},
					live_grep = {
						additional_args = function()
							return { "--hidden" }
						end,
					},
				},
			}
		end,
	},
}
