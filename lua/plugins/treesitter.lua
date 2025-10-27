return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		-- Add the textobjects plugin as a dependency
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = {
				-- Your original list
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"elixir",
				"heex",
				"javascript",
				"html",
				"markdown",
				"markdown_inline",
				"typescript",
				"css",
				"json",
				"vue",
			},

			auto_install = true,
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },

			-- CORRECT: This is a top-level configuration block
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<Enter>",
					node_incremental = "<Enter>",
					scope_incremental = false,
					node_decremental = "<Backspace>",
				},
			},

			-- This is the separate, top-level textobjects configuration block
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
			},
		})
	end,
}
