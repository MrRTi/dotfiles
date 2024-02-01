return {
  {
    "ThePrimeagen/harpoon",
    opts = function()
      return {
        menu = {
          width = vim.api.nvim_win_get_width(0) - 10,
        },
      }
    end,
    config = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "[h]arpoon [a]dd" })
      vim.keymap.set("n", "<leader>hq", ui.toggle_quick_menu, { desc = "[h]arpoon [q]uick menu" })

      vim.keymap.set("n", "<leader>h]", function()
        ui.nav_next()
      end, { desc = '[h]arpoon ["["] (next)' })

      vim.keymap.set("n", "<leader>h[", function()
        ui.nav_prev()
      end, { desc = '[h]arpoon ["]"] (prev)' })

      vim.keymap.set("n", "<leader>hl", function()
        ui.nav_next()
      end, { desc = "[h]arpoon [l] (next)" })

      vim.keymap.set("n", "<leader>hh", function()
        ui.nav_prev()
      end, { desc = "[h]arpoon [h] (prev)" })
    end,
  },
}
