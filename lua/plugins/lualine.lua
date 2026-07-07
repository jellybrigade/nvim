return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  opts = {
    options = {
      theme = 'everforest',
      icons_enabled = vim.g.have_nerd_font,
    },
  },
}
