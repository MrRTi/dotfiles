return {
  -- Working with git worktrees in nvim
  {
    "ThePrimeagen/git-worktree.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      {
        "<leader>gwa",
        "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
        desc = "[g]it [w]orktree [a]dd",
      },
      {
        "<leader>gws",
        "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
        desc = "[g]it [w]orktree [s]how",
      },
    },
  },
}
