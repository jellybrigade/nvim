return {
	{
		"github/copilot.vim",
		event = "InsertEnter",
		config = function()
			-- Minimal sensible defaults; users can customize further in their own config
			-- Use <Tab> to accept, <C-]> to next, <C-[> to previous as common mappings
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true

			-- Map accept and navigation keys in insert mode
			-- Create a small Lua helper that Copilot Tab mapping will call via v:lua
			-- Use the official recommended expression mapping: call copilot#Accept() directly
			-- This returns a string to insert: empty when a suggestion was accepted, or a tab fallback
			vim.api.nvim_set_keymap("i", "<Tab>", "copilot#Accept('\\<Tab>')", { expr = true, noremap = true, silent = true })
			vim.api.nvim_set_keymap("i", "<C-]>", "copilot#Next()", { expr = true, noremap = true, silent = true })
			-- Avoid mapping <C-[> because it's equivalent to <Esc> and prevents leaving insert mode.
			-- Use Alt-[ (M-[) for previous suggestion instead.
			vim.api.nvim_set_keymap("i", "<M-[>", "copilot#Previous()", { expr = true, noremap = true, silent = true })
		end,
	},
}
