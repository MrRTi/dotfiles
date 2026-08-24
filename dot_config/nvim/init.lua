-- Options

vim.g.mapleader = " "

vim.o.number = true
vim.o.relativenumber = false
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.swapfile = false
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
vim.o.background = "dark"

vim.opt.scrolloff = 999
vim.opt.sidescrolloff = 999
vim.opt.cursorline = true

-- NOTE: Default indent: 2 spaces (covers ruby, lua, yaml, json, javascript, shell)
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

local indent_overrides = {
  python = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true },
  go = { tabstop = 8, shiftwidth = 8, softtabstop = 0, expandtab = false },
  make = { tabstop = 8, shiftwidth = 8, softtabstop = 0, expandtab = false },
  dockerfile = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true },
}

for filetype, opts in pairs(indent_overrides) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetype,
    callback = function()
      vim.bo.tabstop = opts.tabstop
      vim.bo.shiftwidth = opts.shiftwidth
      vim.bo.softtabstop = opts.softtabstop
      vim.bo.expandtab = opts.expandtab
    end,
  })
end

-- Folds via treesitter; start with all folds open
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldenable = false
vim.o.foldlevel = 99

-- NOTE: Add ability to use йцукен letters same as qwerty. (symbols like :, $ etc won't work as expected)
vim.o.langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;"
    .. "ABCDEFGHIJKLMNOPQRSTUVWXYZ,"
    .. "фисвуапршолдьтщзйкыегмцчня;"
    .. "abcdefghijklmnopqrstuvwxyz,"

-- Plugins

vim.keymap.set("n", "<leader>pu", function()
  vim.pack.update()
end, { desc = "Update plugins" })

vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/echasnovski/mini.ai" },
  { src = "https://github.com/echasnovski/mini.splitjoin" },
  { src = "https://github.com/echasnovski/mini.indentscope" },
  { src = "https://github.com/echasnovski/mini.statusline" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/NeogitOrg/neogit" },
  { src = "https://github.com/sindrets/diffview.nvim" },
  {
    src = "https://github.com/ThePrimeagen/harpoon",
    version = "harpoon2",
  },
  { src = "https://github.com/nvimtools/none-ls.nvim" },
  { src = "https://github.com/nvimtools/none-ls-extras.nvim" },
  { src = "https://github.com/gbprod/none-ls-shellcheck.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/nvim-neotest/neotest" },
  { src = "https://github.com/olimorris/codecompanion.nvim" },
  { src = "https://github.com/ravitemer/mcphub.nvim" },
  { src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
  -- deps
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/olimorris/neotest-rspec" },
  --
  { src = "https://github.com/andythigpen/nvim-coverage" },
  -- Theme
  { src = "https://github.com/rebelot/kanagawa.nvim" },
})

-- Appearance

local function is_dark_local()
  local handle =
      io.popen([[osascript -e 'tell application "System Events" to tell appearance preferences to get dark mode']])
  if not handle then
    return false
  end
  local result = handle:read("*a")
  handle:close()
  return result:lower():gsub("%s+", "") == "true"
end

local function toggle_appearance(toggle_to)
  toggle_to = toggle_to or (vim.o.background == "light" and "dark" or "light")
  vim.o.background = toggle_to
end

require("kanagawa").setup({
  transparent = true,
  background = { dark = "dragon", light = "lotus" },
})
vim.cmd("colorscheme kanagawa")

vim.cmd("hi NormalFloat guibg=NONE")
vim.cmd("hi FloatBorder guibg=NONE")

if is_dark_local() then
  toggle_appearance("dark")
else
  toggle_appearance("light")
end

-- UI

require("todo-comments").setup()
require("mini.ai").setup()
require("mini.splitjoin").setup()
require("mini.indentscope").setup()
local function colored_diagnostics()
  local severities = {
    [1] = { "E", "DiagnosticError" },
    [2] = { "W", "DiagnosticWarn" },
    [3] = { "I", "DiagnosticInfo" },
    [4] = { "H", "DiagnosticHint" },
  }
  local parts = {}
  for sev, v in pairs(severities) do
    local n = #vim.diagnostic.get(0, { severity = sev })
    if n > 0 then
      table.insert(parts, string.format("%%#%s#%s:%d", v[2], v[1], n))
    end
  end
  return #parts > 0 and (" " .. table.concat(parts, " ") .. " %#MiniStatuslineDevinfo#") or ""
end

local function lsp_clients()
  local clients = vim.tbl_filter(function(c)
    return c.name ~= "null-ls"
  end, vim.lsp.get_clients({ bufnr = 0 }))
  return #clients > 0 and table.concat(
    vim.tbl_map(function(c)
      return c.name
    end, clients),
    " "
  ) or ""
end

require("mini.statusline").setup({
  use_icons = true,
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local git = MiniStatusline.section_git({ trunc_width = 75 })
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      local location = MiniStatusline.section_location({ trunc_width = 75 })

      local lsp = lsp_clients()
      local ft = vim.bo.filetype
      local lsp_ft = lsp ~= "" and (lsp .. " · " .. ft) or ft

      return MiniStatusline.combine_groups({
        { hl = mode_hl,                 strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { git } },
        "%<",
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=",
        colored_diagnostics(),
        { hl = "MiniStatuslineDevinfo", strings = { lsp_ft } },
        { hl = mode_hl, strings = { "󰡏 %l/%L 󰡎 %c/%{col('$')-1}" } },
      })
    end,
  },
})

require("which-key").setup()
require("which-key").add({
  { "<leader>v", group = "ai" },
  { "<leader>b", group = "buffer" },
  { "<leader>f", group = "file" },
  { "<leader>g", group = "git" },
  { "<leader>l", group = "lsp" },
  { "<leader>s", group = "search" },
  { "<leader>t", group = "test" },
  { "<leader>p", group = "plugins" },
  { "<leader>u", group = "ui" },
  { "[",         group = "prev" },
  { "]",         group = "next" },
})

vim.keymap.set("n", "<leader>ut", toggle_appearance, { desc = "Toggle light/dark" })
vim.keymap.set("n", "<leader>uT", function()
  local buf = vim.api.nvim_get_current_buf()
  if vim.treesitter.highlighter.active[buf] then
    vim.treesitter.stop()
  else
    vim.treesitter.start()
  end
end, { desc = "Toggle treesitter highlight" })

-- File explorer

require("oil").setup({
  view_options = { show_hidden = true },
})

vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>-", "<cmd>Oil<CR>", { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>fp", '<cmd>let @+ = fnamemodify(expand("%:p"), ":~:.")<CR>', { desc = "Copy path" })

-- Search

local fzf_grep_normal = {
  rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
  header = ":: <ctrl-g> to Fuzzy Search | :: <alt-m> to Multiline Mode",
}
local fzf_grep_multiline = {
  rg_opts = "--multiline --column --line-number --no-heading --color=always --smart-case",
  header = ":: <ctrl-g> to Fuzzy Search | :: <alt-m> to Normal Mode",
}
fzf_grep_normal.actions = {
  ["alt-m"] = function(_, _)
    require("fzf-lua").live_grep(vim.tbl_extend("force", fzf_grep_multiline, { resume = true }))
  end,
}
fzf_grep_multiline.actions = {
  ["alt-m"] = function(_, _)
    require("fzf-lua").live_grep(vim.tbl_extend("force", fzf_grep_normal, { resume = true }))
  end,
}
require("fzf-lua").setup({
  winopts = { preview = { layout = "vertical" } },
  grep = fzf_grep_normal,
  keymap = {
    fzf = {
      true,
      -- NOTE: Use <c-q> to select all items and add them to the quickfix list
      ["ctrl-q"] = "select-all+accept",
    },
  },
})

vim.keymap.set("n", "<leader><space>", "<cmd>FzfLua global<CR>", { desc = "Search files and buffers" })
vim.keymap.set("n", "<leader>sf", "<cmd>FzfLua files<CR>", { desc = "Files" })
vim.keymap.set("n", "<leader>sg", "<cmd>FzfLua live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>sw", "<cmd>FzfLua grep_cword<CR>", { desc = "Word under cursor" })
vim.keymap.set("n", "<leader>sh", "<cmd>FzfLua helptags<CR>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>sk", "<cmd>FzfLua keymaps<CR>", { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sr", "<cmd>FzfLua resume<CR>", { desc = "Resume last search" })
vim.keymap.set("n", "<leader>st", "<cmd>TodoFzfLua<CR>", { desc = "Search todos/notes" })

-- Treesitter
-- NOTE: nvim-treesitter main branch (Neovim 0.12+) only manages parser installation.
-- Highlighting is handled natively by Neovim.

require("nvim-treesitter").install({ "lua", "ruby", "python", "javascript", "yaml", "json" })

-- LSP

vim.lsp.config("lua_ls", {
  settings = {
    Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true) } },
  },
})

vim.lsp.enable({ "lua_ls", "ruby_lsp", "pyright", "ruff", "yamlls", "marksman", "gopls" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.server_capabilities.completionProvider then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    for _, client in ipairs(vim.lsp.get_clients()) do
      client:stop()
    end
  end,
})

-- Built-in LSP completion: fuzzy matching, show menu, don't auto-insert
vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect", "fuzzy" }

-- NOTE: grr (references), grn (rename), gra (code action), gri (implementation)
--       are Neovim 0.11 built-ins and appear in which-key automatically.
vim.keymap.set({ "n", "v" }, "<leader>lf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Diagnostic float" })
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })

-- Formatting & diagnostics (null-ls)

local null_ls = require("null-ls")
local augroup_format = vim.api.nvim_create_augroup("NullLsFormat", { clear = true })

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.completion.spell,
    -- Python
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
    require("none-ls.diagnostics.flake8"),
    -- Ruby
    null_ls.builtins.formatting.rubocop,
    null_ls.builtins.diagnostics.rubocop,
    -- JSON
    require("none-ls.formatting.jq"),
    -- YAML
    -- null_ls.builtins.formatting.yamlfmt,
    -- Shell
    null_ls.builtins.formatting.shfmt,
    require("none-ls-shellcheck.diagnostics"),
  },
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup_format,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})

-- Navigation (tmux + harpoon)

-- NOTE: Tmux-aware pane navigation (replaces vim-tmux-navigator plugin)
local function tmux_navigate(direction)
  local tmux_dir = ({ h = "L", j = "D", k = "U", l = "R" })[direction]
  local win = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. direction)
  if vim.api.nvim_get_current_win() == win and vim.env.TMUX then
    vim.fn.system("tmux select-pane -" .. tmux_dir)
  end
end

for _, dir in ipairs({ "h", "j", "k", "l" }) do
  vim.keymap.set("n", "<C-" .. dir .. ">", function()
    tmux_navigate(dir)
  end, { desc = "Navigate " .. dir })
end

local harpoon = require("harpoon")
harpoon.setup()

vim.keymap.set("n", "<leader>H", function()
  harpoon:list():add()
end, { desc = "Add file to harpoon" })
vim.keymap.set("n", "<leader>h", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Toggle harpoon menu" })
vim.keymap.set("n", "[H", function()
  harpoon:list():prev()
end, { desc = "Previous harpoon file" })
vim.keymap.set("n", "]H", function()
  harpoon:list():next()
end, { desc = "Next harpoon file" })

-- AI

require("mcphub").setup()

-- blink.cmp: used only for codecompanion's chat buffer (@tool/#var/slash-command
-- popup) — sources.default stays empty so it stays inert in normal buffers and
-- doesn't fight the native LSP completion set up above. codecompanion registers
-- its own filetype-scoped source at runtime (providers/completion/blink/setup.lua).
-- fuzzy.implementation = "lua" avoids the Rust prebuilt/build-step blink.cmp
-- normally wants — vim.pack.add has no build-hook mechanism to run it.
require("blink.cmp").setup({
  sources = { default = {} },
  fuzzy = { implementation = "lua" },
})

require("codecompanion").setup({
  extensions = {
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        make_tools = true,
        show_server_tools_in_chat = true,
        add_mcp_prefix_to_tool_names = false,
        show_result_in_chat = true,
        -- mcphub's make_vars targets codecompanion's old config.interactions.chat.variables
        -- table, which the installed codecompanion.nvim removed (replaced by its
        -- context/editor_context system) -> pairs(nil) crash on chat open. Off until
        -- mcphub.nvim's codecompanion extension catches up.
        make_vars = false,
        make_slash_commands = true,
      },
    },
  },
  adapters = {
    http = {
      llm_serve = function()
        local url = os.getenv("LLM_SERVE_URL") or "http://127.0.0.1:8090"
        return require("codecompanion.adapters").extend("openai_compatible", {
          env = {
            url = url,
            api_key = "not-needed",
            chat_url = "/v1/chat/completions",
          },
          handlers = {
            -- mlx_lm.server puts Qwen3's <think> reasoning in delta.reasoning
            -- (not the reasoning_content name most providers use). Without
            -- this, codecompanion only reads delta.content and the buffer
            -- shows nothing at all while the model is thinking.
            parse_meta = function(self, data)
              local reasoning_content = data.extra and data.extra.reasoning
              if reasoning_content then
                data.output.reasoning = { content = reasoning_content }
                if data.output.content == "" then
                  data.output.content = nil
                end
              end
              return data
            end,
          },
        })
      end,
    },
  },
  interactions = {
    chat = {
      adapter = "llm_serve",
      opts = { completion_provider = "blink" },
    },
    inline = { adapter = "llm_serve" },
  },
})

-- <leader>a is avante's own namespace (its default mappings, e.g. <leader>ac
-- "add current buffer", live there and aren't declared in this file) — moved
-- codecompanion under <leader>v instead of fighting over the same keys.
vim.keymap.set("n", "<leader>vc", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Toggle AI chat" })
vim.keymap.set("v", "<leader>vi", "<cmd>CodeCompanion<CR>", { desc = "AI inline edit" })
vim.keymap.set("n", "<leader>vm", "<cmd>MCPHub<CR>", { desc = "MCP Hub panel" })

-- In-buffer spinner: vim.notify alone was easy to miss (no notify UI plugin
-- installed, just a cmdline echo that gets overwritten). This puts an animated
-- "generating…" virtual line at the bottom of the chat buffer itself for the
-- duration of the request, so there's visible feedback right where you're
-- looking after <C-s>.
local codecompanion_group = vim.api.nvim_create_augroup("CodeCompanionNotify", { clear = true })
local codecompanion_spinner_ns = vim.api.nvim_create_namespace("codecompanion_spinner")
local codecompanion_spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local codecompanion_spinner_timer = nil

local function codecompanion_spinner_stop(bufnr)
  if codecompanion_spinner_timer then
    codecompanion_spinner_timer:stop()
    codecompanion_spinner_timer:close()
    codecompanion_spinner_timer = nil
  end
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_clear_namespace(bufnr, codecompanion_spinner_ns, 0, -1)
  end
end

vim.api.nvim_create_autocmd("User", {
  pattern = "CodeCompanionRequestStarted",
  group = codecompanion_group,
  callback = function(request)
    local bufnr = request.data and request.data.bufnr
    if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end
    codecompanion_spinner_stop(bufnr)
    local frame = 1
    codecompanion_spinner_timer = vim.uv.new_timer()
    codecompanion_spinner_timer:start(0, 100, function()
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return codecompanion_spinner_stop()
        end
        vim.api.nvim_buf_clear_namespace(bufnr, codecompanion_spinner_ns, 0, -1)
        local last_line = vim.api.nvim_buf_line_count(bufnr) - 1
        vim.api.nvim_buf_set_extmark(bufnr, codecompanion_spinner_ns, last_line, 0, {
          virt_lines = { { { codecompanion_spinner_frames[frame] .. " generating…", "Comment" } } },
        })
        frame = (frame % #codecompanion_spinner_frames) + 1
      end)
    end)
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "CodeCompanionRequestFinished",
  group = codecompanion_group,
  callback = function(request)
    local bufnr = request.data and request.data.bufnr
    codecompanion_spinner_stop(bufnr)
    local status = request.data and request.data.status
    if status ~= "success" then
      vim.schedule(function()
        vim.notify("CodeCompanion: request failed (" .. tostring(status) .. ")", vim.log.levels.WARN)
      end)
    end
  end,
})

-- Git

require("gitsigns").setup()
require("neogit").setup({ integrations = { diffview = true } })

vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Git status" })
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Diff all changes" })
vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewFileHistory %<CR>", { desc = "File history" })
vim.keymap.set("n", "<leader>gP", function()
  require("neogit").open({ "push" })
end, { desc = "Push" })
vim.keymap.set("n", "<leader>gG", function()
  vim.cmd("tabnew | terminal lazygit")
  vim.cmd("startinsert")
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = 0,
    callback = function()
      vim.cmd("bdelete!")
    end,
  })
end, { desc = "LazyGit" })
vim.keymap.set({ "n", "v" }, "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame line" })
vim.keymap.set({ "n", "v" }, "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Preview hunk" })
vim.keymap.set({ "n", "v" }, "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", { desc = "Stage buffer" })
vim.keymap.set("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Undo stage hunk" })
vim.keymap.set("n", "<leader>gq", "<cmd>Gitsigns setqflist<CR>", { desc = "Hunks to quickfix" })
vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous hunk" })
vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next hunk" })

-- Testing

require("coverage").setup({ auto_reload = true })
require("neotest").setup({
  adapters = { require("neotest-rspec") },
})

local function ruby_spec(on_success)
  local f = vim.fn.expand("%:p")
  local spec = f:gsub("/app/(.+)%.rb$", "/spec/%1_spec.rb")
  if spec == f then
    spec = f:gsub("/lib/(.+)%.rb$", "/spec/lib/%1_spec.rb")
  end
  if spec == f then
    spec = f:gsub("_spec%.rb$", ".rb"):gsub("/spec/(.+)%.rb$", "/app/%1.rb")
  end
  spec = spec ~= f and spec or nil
  if spec and vim.fn.filereadable(spec) == 1 then
    on_success(spec)
  else
    require("fzf-lua").files({ query = vim.fn.expand("%:t:r") .. "_spec" })
  end
end

vim.keymap.set("n", "<leader>tn", function()
  require("neotest").run.run()
end, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run test file" })
vim.keymap.set("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, { desc = "Toggle summary" })
vim.keymap.set("n", "<leader>to", function()
  require("neotest").output_panel.toggle()
end, { desc = "Toggle output" })
vim.keymap.set("n", "<leader>ta", function()
  if vim.bo.filetype == "ruby" then
    ruby_spec(function(spec)
      vim.cmd("edit " .. spec)
    end)
  else
    vim.notify("No spec finder for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
  end
end, { desc = "Go to related spec" })
vim.keymap.set("n", "<leader>tA", function()
  if vim.bo.filetype == "ruby" then
    ruby_spec(function(spec)
      require("neotest").run.run(spec)
    end)
  else
    vim.notify("No spec finder for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
  end
end, { desc = "Run related spec" })
vim.keymap.set("n", "<leader>tc", "<cmd>Coverage<CR>", { desc = "Load coverage" })
vim.keymap.set("n", "<leader>uc", "<cmd>CoverageToggle<CR>", { desc = "Toggle coverage" })
vim.keymap.set("n", "]t", function()
  require("neotest").jump.next({ status = "failed" })
end, { desc = "Next failed test" })
vim.keymap.set("n", "[t", function()
  require("neotest").jump.prev({ status = "failed" })
end, { desc = "Prev failed test" })

-- Buffer

vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Autocmds

local dw_ns = vim.api.nvim_create_namespace("double_width_chars")

local function check_double_width(bufnr)
  local diagnostics = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for lnum, line in ipairs(lines) do
    for col, char in line:gmatch("()([\128-\255])") do
      table.insert(diagnostics, {
        lnum = lnum - 1,
        col = col - 1,
        end_col = col - 1 + #char,
        severity = vim.diagnostic.severity.WARN,
        message = "Non-ASCII character (double-width risk)",
        source = "double-width",
      })
    end
  end
  vim.diagnostic.set(dw_ns, bufnr, diagnostics)
end

vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave" }, {
  callback = function(ev)
    check_double_width(ev.buf)
  end,
})

vim.keymap.set("n", "<leader>fd", function()
  vim.fn.setreg("/", [=[[^\x00-\x7E]]=])
  vim.o.hlsearch = true
  vim.diagnostic.setqflist({ namespace = dw_ns, open = true })
end, { desc = "Find double-width chars" })

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})
