return {
  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
        config = function()
          -- Enable telescope fzf native, if installed
          pcall(require("telescope").load_extension, "fzf")
        end,
      },
    },
    keys = {
      -- See `:help telescope.builtin`
      { "<leader>?",       require("telescope.builtin").oldfiles, desc = "[?] Find recently opened files" },
      { "<leader><space>", require("telescope.builtin").buffers,  desc = "[ ] Find existing buffers" },
      {
        "<leader>/",
        function()
          -- You can pass additional configuration to telescope to change theme, layout, etc.
          require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
            winblend = 10,
            previewer = false,
          }))
        end,
        desc = "[/] Fuzzily search in current buffer",
      },

      { "<leader>gf", require("telescope.builtin").git_files,   desc = "Search [g]it [f]iles" },
      { "<leader>sf", require("telescope.builtin").find_files,  desc = "[s]earch [f]iles" },
      { "<leader>ss", "/",                                      desc = "[ss]earch in file" },
      { "<leader>sh", require("telescope.builtin").help_tags,   desc = "[s]earch [h]elp" },
      { "<leader>sw", require("telescope.builtin").grep_string, desc = "[s]earch current [w]ord" },
      { "<leader>sg", require("telescope.builtin").live_grep,   desc = "[s]earch by [g]rep" },
      { "<leader>sd", require("telescope.builtin").diagnostics, desc = "[s]earch [d]iagnostics" },
      { "<leader>sr", require("telescope.builtin").resume,      desc = "[s]earch [r]esume" },
    },
    opts = function()
      -- See `:help telescope` and `:help telescope.setup()`
      return {
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = {
              "rg",
              "--no-ignore",
              "--hidden",
              "--files",
              "-g",
              "!**/node_modules/*",
              "-g",
              "!**/.git/*",
            },
          },
        },
      }
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      require("telescope").load_extension("ui-select")
    end,
  },
}
