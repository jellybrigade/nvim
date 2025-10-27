-- ~/.config/nvim/lua/plugins/lsp.lua

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "j-hui/fidget.nvim", opts = {} },
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Create a capabilities object with formatting disabled
		local no_format_capabilities = vim.deepcopy(capabilities)
		no_format_capabilities.textDocument.documentFormatting = false
		no_format_capabilities.textDocument.rangeFormatting = false

		-- Use the new vim.lsp.config API
		vim.lsp.config("ts_ls", { capabilities = no_format_capabilities })
		vim.lsp.config("eslint", { capabilities = no_format_capabilities })
		vim.lsp.config("html", { capabilities = no_format_capabilities })
		vim.lsp.config("cssls", { capabilities = no_format_capabilities })
		vim.lsp.config("jsonls", { capabilities = no_format_capabilities })
		vim.lsp.config("vuels", { capabilities = no_format_capabilities })
		vim.lsp.config("tailwindcss", { capabilities = no_format_capabilities })
		vim.lsp.config("graphql", { capabilities = no_format_capabilities }) -- Add GraphQL LSP
		vim.lsp.config("yamlls", { capabilities = no_format_capabilities }) -- Add YAML LSP

		-- Enable the configured LSPs for buffers that match
		vim.lsp.enable(
			"ts_ls",
			"eslint",
			"html",
			"cssls",
			"jsonls",
			"vuels",
			"tailwindcss",
			"graphql", -- Add to enable list
			"yamlls" -- Add to enable list
		)

		-- Keybindings for LSP
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf }

				vim.keymap.set(
					"n",
					"gD",
					vim.lsp.buf.declaration,
					vim.tbl_extend("force", opts, { desc = "Go to [D]eclaration" })
				)
				vim.keymap.set(
					"n",
					"gd",
					vim.lsp.buf.definition,
					vim.tbl_extend("force", opts, { desc = "Go to [d]efinition" })
				)
				vim.keymap.set(
					"n",
					"K",
					vim.lsp.buf.hover,
					vim.tbl_extend("force", opts, { desc = "Hover information" })
				)
				vim.keymap.set(
					"n",
					"gi",
					vim.lsp.buf.implementation,
					vim.tbl_extend("force", opts, { desc = "Go to [i]mplementation" })
				)
				vim.keymap.set(
					"n",
					"<C-k>",
					vim.lsp.buf.signature_help,
					vim.tbl_extend("force", opts, { desc = "Signature help" })
				)
				vim.keymap.set(
					{ "n", "v" },
					"<space>ca",
					vim.lsp.buf.code_action,
					vim.tbl_extend("force", opts, { desc = "[C]ode [A]ction" })
				)
				vim.keymap.set(
					"n",
					"gr",
					vim.lsp.buf.references,
					vim.tbl_extend("force", opts, { desc = "Goto [r]eferences" })
				)
				vim.keymap.set(
					"n",
					"<space>D",
					vim.lsp.buf.type_definition,
					vim.tbl_extend("force", opts, { desc = "Go to Type [D]efinition" })
				)
				vim.keymap.set(
					"n",
					"<space>rn",
					vim.lsp.buf.rename,
					vim.tbl_extend("force", opts, { desc = "[R]e[n]ame symbol" })
				)
				vim.keymap.set(
					"n",
					"<space>wa",
					vim.lsp.buf.add_workspace_folder,
					vim.tbl_extend("force", opts, { desc = "[W]orkspace [A]dd folder" })
				)
				vim.keymap.set(
					"n",
					"<space>wr",
					vim.lsp.buf.remove_workspace_folder,
					vim.tbl_extend("force", opts, { desc = "[W]orkspace [R]emove folder" })
				)
				vim.keymap.set("n", "<space>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, vim.tbl_extend("force", opts, { desc = "[W]orkspace [L]ist folders" }))
				vim.keymap.set(
					"n",
					"<space>e",
					vim.diagnostic.open_float,
					vim.tbl_extend("force", opts, { desc = "Show diagnostic [E]rror" })
				)
				vim.keymap.set(
					"n",
					"[d",
					vim.diagnostic.goto_prev,
					vim.tbl_extend("force", opts, { desc = "Go to previous [D]iagnostic" })
				)
				vim.keymap.set(
					"n",
					"]d",
					vim.diagnostic.goto_next,
					vim.tbl_extend("force", opts, { desc = "Go to next [D]iagnostic" })
				)
			end,
		})
	end,
}
