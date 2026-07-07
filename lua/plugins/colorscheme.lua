return {
  {
    'neanias/everforest-nvim',
    priority = 1000,
    lazy = false,
    opts = {
      background = 'medium',
      transparent_background_level = 0,
      italics = true,
    },
    config = function(_, opts)
      require('everforest').setup(opts)
      vim.cmd.colorscheme 'everforest'
    end,
  },
}
