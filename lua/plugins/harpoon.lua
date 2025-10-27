-- ~/.config/nvim/lua/plugins/harpoon.lua

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup({})
		-- REQUIRED

		-- Keybindings
		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "[H]arpoon [A]dd file" })
		vim.keymap.set("n", "<leader>hh", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "[H]arpoon Toggle menu" })

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<leader>hp", function()
			harpoon:list():prev()
		end, { desc = "[H]arpoon [P]revious" })
		vim.keymap.set("n", "<leader>hn", function()
			harpoon:list():next()
		end, { desc = "[H]arpoon [N]ext" })

		-- Set <space>1..<space>5 to navigate directly to the first 5 harpoon marks
		for i = 1, 5 do
			vim.keymap.set("n", string.format("<leader>%d", i), function()
				harpoon:list():select(i)
			end, { desc = string.format("Harpoon Goto mark %d", i) })
		end
	end,
}
