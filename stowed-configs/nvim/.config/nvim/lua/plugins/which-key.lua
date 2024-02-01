return {
  -- Useful plugin to show you pending keybinds.
  {
    "folke/which-key.nvim",
    opts = {},
    config = function()
      require("which-key").register({
        ["<leader>b"] = { name = "[b]uffer", _ = "which_key_ignore" },
        ["<leader>c"] = { name = "[c]ode", _ = "which_key_ignore" },
        ["<leader>f"] = { name = "[f]ile", _ = "which_key_ignore" },
        ["<leader>d"] = { name = "[d]iagnostics", _ = "which_key_ignore" },
        ["<leader>g"] = { name = "[g]it", _ = "which_key_ignore" },
        ["<leader>gh"] = { name = "[g]it [h]unk", _ = "which_key_ignore" },
        ["<leader>gw"] = { name = "[g]it [w]orktree", _ = "which_key_ignore" },
        ["<leader>h"] = { name = "[h]arpoon", _ = "which_key_ignore" },
        ["<leader>r"] = { name = "[r]ename", _ = "which_key_ignore" },
        ["<leader>s"] = { name = "[s]earch", _ = "which_key_ignore" },
        ["<leader>w"] = { name = "[w]orkspace", _ = "which_key_ignore" },
        ["<leader>p"] = { name = "[p]roject", _ = "which_key_ignore" },
      })
    end,
  },
}
