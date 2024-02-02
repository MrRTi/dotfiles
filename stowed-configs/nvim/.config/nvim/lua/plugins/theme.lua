return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      -- vim.cmd.set("background=light")
      -- vim.cmd.colorscheme("rose-pine")
      require("rose-pine").setup({
        dark_variant = "moon",
      })
    end,
  },
  {
    "cormacrelf/dark-notify",
    config = function()
      require("dark_notify").run({
        schemes = {
          dark = {
            colorscheme = "rose-pine",
            background = "dark",
          },
          light = {
            colorscheme = "rose-pine",
            background = "light",
          },
        },
      })
    end,
  },
}
