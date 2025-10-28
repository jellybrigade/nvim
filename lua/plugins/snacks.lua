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
      keys = {
        { key = "f", desc = "Smart Files", action = "smart" },
        { key = "g", desc = "Grep",        action = "live_grep" },
        {
          key = "r",
          desc = "Restore Session",
          action = function()
            local session_file = vim.fn.getcwd() .. "/.vim/Session.vim"
            if vim.fn.filereadable(session_file) == 1 then
              require("auto-session.lib").RestoreSession()
            else
              vim.notify("No session found for this directory.", vim.log.levels.WARN)
            end
          end,
        },
      },
      sections = {
        { section = "header" },
        { section = "keys",         gap = 1,   padding = 1 },
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
        live_grep = { hidden = true },
        notifications = {},
      },
    },
  },
  keys = {
    {
      "<leader>g",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader><space>",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Files",
    },
    {
      "<leader>b",
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

