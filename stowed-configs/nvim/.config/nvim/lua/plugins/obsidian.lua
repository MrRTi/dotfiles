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
			desc = "[o]bsidian [s]earch with grep",
		},
	},
}
