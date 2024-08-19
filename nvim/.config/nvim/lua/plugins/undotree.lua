return {
	{
		"mbbill/undotree",
		config = function()
			-- Open undotree
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "[U]ndotree" })
		end,
	},
}
-- vim: ts=2 sts=2 sw=2 et
