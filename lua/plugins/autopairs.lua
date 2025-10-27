return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	dependencies = { "hrsh7th/nvim-cmp" }, -- Optional: for integration with nvim-cmp
	config = function()
		require("nvim-autopairs").setup({
			-- You can add custom options here
			check_ts = true, -- enable treesitter integration
		})

		-- If you want to integrate with nvim-cmp
		local cmp = require("cmp")
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
