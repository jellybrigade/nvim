return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		notifier = {
			enabled = true,
			history = { enabled = true },
		},
		quickfile = { enabled = true },
		words = { enabled = true },
		scope = { enabled = true },
		styles = {
			notification = { wo = { wrap = false } },
		},
		terminal = { enabled = true },
		dashboard = {
			enabled = true,
			-- Define your custom keys here
			keys = {
				{ key = "f", desc = "Find File", action = "files" },
				{ key = "g", desc = "Grep", action = "live_grep" },
				{
					key = "r",
					desc = "Restore Session",
					action = function()
						-- Check if a session exists before trying to restore
						if vim.fn.filereadable(vim.fn.getcwd() .. "/.vim/Session.vim") == 1 then
							require("auto-session.lib").RestoreSession()
						else
							vim.notify("No session found for this directory.", vim.log.levels.WARN)
						end
					end,
				},
			},
			sections = {
				{ section = "header" },
				-- Use the built-in keys section, which will now display your custom keys
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "recent_files", limit = 8, padding = 1 },
				{ section = "startup" },
			},
		},
		picker = {
			sources = {
				files = {
					hidden = true,
					ignored = true,
				},
				grep = {},
				notifications = {},
			},
		},
	},
	keys = {
		{
			"<leader>/",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader><space>",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Find Buffers",
		},
		{
			"<leader>fn",
			function()
				Snacks.picker.notifications()
			end,
			desc = "[F]ind [N]otifications",
		},
		{
			"<leader>t",
			function()
				Snacks.terminal()
			end,
			desc = "Toggle Terminal",
		},
	},
	init = function()
		vim.api.nvim_create_user_command("Grep", function(opts)
			Snacks.picker.grep(opts.args)
		end, { nargs = "?" })
	end,
}
