return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default"
      },
      completion = {
        ghost_text = {
          enabled = function()
            if vim.api.nvim_get_mode().mode ~= "i" then
              return false
            end

            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            local row = cursor_pos[1]
            local col = cursor_pos[2]

            local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
            local charater = line:sub(col + 1, col + 1)

            if (charater == nil or charater:match("%w") == nil) then
              return true
            end

            return false
          end,
        }
      }
    }
  }
}
