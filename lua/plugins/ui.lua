return {
	-- Easily create and manage predefined window layouts
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		opts = {
			-- Globally disable edgy.nvim animations
			animate = {
				enabled = false,
			},
			-- Define which windows should go on the right side
			right = {},
		},
	},

	-- Highlight and search for todo comments
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
}
