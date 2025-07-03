return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters = {
      rubocop = {
        -- Change where to find the command
        command = "bundle",
        args = {
          "exec",
          "rubocop",
          "--server",
          "-a",
          "-f",
          "quiet",
          "--stderr",
          "--stdin",
          "$FILENAME",
        },
      },
    },
    formatters_by_ft = {
      ruby = { formatter },
      eruby = { "erb_format" },
    },
  },
}
