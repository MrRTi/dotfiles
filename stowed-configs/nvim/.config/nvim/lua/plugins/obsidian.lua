return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	-- lazy = true,
	-- Place current file path in clipboard
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
	--   "BufReadPre path/to/my-vault/**.md",
	--   "BufNewFile path/to/my-vault/**.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",

		-- see below for full list of optional dependencies 👇
	},
	opts = {
		workspaces = {
			{
				name = "personal",
				path = "~/vaults/personal",
			},
		},

		notes_subdir = "000_inbox",

		-- Where to put new notes. Valid options are
		--  * "current_dir" - put new notes in same directory as the current buffer.
		--  * "notes_subdir" - put new notes in the default notes subdirectory.
		new_notes_location = "notes_subdir",

		templates = {
			folder = "800_templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
			-- A map for custom variables, the key should be the variable and the value a function
			substitutions = {},
		},

		daily_notes = {
			-- Optional, if you keep daily notes in a separate directory.
			folder = "100_daily",
			-- Optional, if you want to change the date format for the ID of daily notes.
			date_format = "%Y-%m-%d",
			-- Optional, if you want to change the date format of the default alias of daily notes.
			alias_format = "%B %-d, %Y",
			-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
			template = "801_daily_template_nvim",
		},
		-- see below for full list of options 👇
		--
		completion = {
			-- Set to false to disable completion.
			nvim_cmp = true,
			-- Trigger completion at 2 chars.
			min_chars = 2,
		},
	},
	keys = {
		{
			"<leader>ow",
			"<cmd>:ObsidianWorkspace<CR>",
			desc = "[o]bsidian [w]orkspace",
		},
		{
			"<leader>of",
			"<cmd>:ObsidianQuickSwitch<CR>",
			desc = "[o]bsidian search [f]iles",
		},
		{
			"<leader>ob",
			"<cmd>:ObsidianBacklinks<CR>",
			desc = "[o]bsidian [b]acklinks",
		},
		{
			"<leader>od",
			"<cmd>:ObsidianDailies<CR>",
			desc = "[o]bsidian [d]aily",
		},
		{
			"<leader>ot",
			"<cmd>:ObsidianToday<CR>",
			desc = "[o]bsidian [t]oday",
		},
		{
			"<leader>os",
			"<cmd>:ObsidianSearch<CR>",
			desc = "[o]bsidian [s]earch with grep or create",
		},
	},
}
