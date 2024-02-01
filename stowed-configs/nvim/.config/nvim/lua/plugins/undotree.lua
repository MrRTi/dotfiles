return {
  -- Add undotree
  {
    "mbbill/undotree",
    config = function()
      -- Open undotree
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "[u]ndotree" })
    end,
  },
}
