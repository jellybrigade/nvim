-- ~/.config/nvim/lua/plugins/cmp.lua

return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"hrsh7th/cmp-nvim-lsp",
		"L3MON4D3/LuaSnip", -- snippet engine
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim", -- vs-code like pictograms
	},
	config = function()
		local cmp = require("cmp")

		local lspkind = require("lspkind")

		-- Copilot-specific highlight removed since using github/copilot.vim (vimscript)

		cmp.setup({
			-- automatically trigger completion on insert/text changes
			completion = {
				autocomplete = { cmp.TriggerEvent.InsertEnter, cmp.TriggerEvent.TextChanged },
				keyword_length = 1,
			},
			-- do not enable cmp.experimental.ghost_text here; keep ghost text off to avoid visual clutter
			-- experimental = { ghost_text = true },
			-- ensure the first candidate is preselected (so Copilot's top suggestion appears selected)
			preselect = cmp.PreselectMode.Item,
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				-- Accept the currently selected item (we preselect the first item above)
				["<CR>"] = cmp.mapping.confirm({ select = true }),
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				-- Primary language sources
				{ name = "nvim_lsp", group_index = 2 }, -- LSP source
				{ name = "luasnip", group_index = 2 }, -- Snippets source
				-- Lower-priority, fallback sources
				{ name = "buffer", group_index = 2 }, -- Buffer source
				{ name = "path", group_index = 2 }, -- Path source
			}),
			-- configure lspkind for vs-code like icons
			formatting = {
				format = lspkind.cmp_format({
					with_text = true,
					menu = {
						nvim_lsp = "[LSP]",
						luasnip = "[Snip]",
						buffer = "[Buffer]",
						path = "[Path]",
					},
				}),
			},
		})

		-- Add a lightweight delayed trigger on InsertEnter for a whitelist of filetypes.
		-- This opens the completion popup once when you enter insert mode to populate the menu.
		local ft_whitelist = {
			lua = true,
			python = true,
			vue = true,
			javascript = true,
			typescript = true,
			go = true,
			rust = true,
			java = true,
			c = true,
			cpp = true,
			sh = true,
		}
		vim.api.nvim_create_autocmd("InsertEnter", {
			callback = function()
				local ft = vim.bo.filetype
				if not ft_whitelist[ft] then
					return
				end
				local ok, cmp = pcall(require, "cmp")
				if not ok then
					return
				end
				-- short delay to allow copilot/cmp sources to initialize when plugin lazy-loads on InsertEnter
				vim.defer_fn(function()
					if not cmp.visible() then
						pcall(function()
							cmp.complete()
						end)
					end
				end, 80)
			end,
		})
	end,
}
