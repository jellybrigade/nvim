-- ~/.config/nvim/lua/plugins/flash.lua

return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {},
    -- stylua: ignore
    keys = {
        { "ss",    mode = { "n", "x", "o" }, function() require("flash").jump() end,                    desc = "Flash" },
        -- Changed 'S' to 'SS' to avoid conflicts with nvim-surround's 'ysS'
        { "SS",    mode = { "n", "x", "o" }, function() require("flash").jump({ backward = true }) end, desc = "Flash Backward" },
        { "r",     mode = "o",               function() require("flash").remote() end,                  desc = "Remote Flash" },
        { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end,       desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,                  desc = "Toggle Flash Search" },
    },
}
