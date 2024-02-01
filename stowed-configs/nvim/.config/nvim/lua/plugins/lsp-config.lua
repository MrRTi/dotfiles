return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			local on_attach = function(_, bufnr)
				local nmap = function(keys, func, desc)
					if desc then
						desc = "LSP: " .. desc
					end

					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
				end

				nmap("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
				nmap("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction")
				nmap("<leader>cf", vim.lsp.buf.format, "[c]ode [f]ormat")

				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
					vim.lsp.buf.format()
				end, { desc = "Format current buffer with LSP" })

				nmap("gd", require("telescope.builtin").lsp_definitions, "[g]oto [d]efinition")
				nmap("gr", require("telescope.builtin").lsp_references, "[g]oto [r]eferences")
				nmap("gI", require("telescope.builtin").lsp_implementations, "[g]oto [I]mplementation")
				nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				nmap("<leader>fs", require("telescope.builtin").lsp_document_symbols, "[f]ile [s]ymbols")
				nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[w]orkspace [s]ymbols")

				-- See `:help K` for why this keymap
				nmap("K", vim.lsp.buf.hover, "Hover Documentation")
				nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

				-- Lesser used LSP functionality
				nmap("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")
				nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[w]orkspace [a]dd Folder")
				nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[w]orkspace [r]emove Folder")
				nmap("<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, "[w]orkspace [l]ist Folders")
			end

			local mason_lspconfig = require("mason-lspconfig")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
			local servers = {
				bashls = {},
				dockerls = {},
				jsonls = {},
				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
				-- -- markdown
				marksman = {},
				ruby_ls = {},
				rubocop = {},
				solargraph = {},
				-- yaml
				hydra_lsp = {},
			}

			require("neodev").setup()

			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			mason_lspconfig.setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
						filetypes = (servers[server_name] or {}).filetypes,
					})
				end,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.diagnostics.eslint,
					null_ls.builtins.diagnostics.rubocop,
					null_ls.builtins.formatting.rubocop,
				},
			})
		end,
	},
}
