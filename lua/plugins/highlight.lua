return {
	{
		"machakann/vim-highlightedyank",
		event = "TextYankPost", -- Load the plugin when text is yanked
		config = function()
			-- The default duration is 200ms. You can change it here.
			-- For example, to make it last 500ms:
			vim.g.highlightedyank_highlight_duration = 500
		end,
	},
}
