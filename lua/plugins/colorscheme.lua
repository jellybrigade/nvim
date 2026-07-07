return {
  {
    "sainnhe/everforest",
    lazy = true,
    priority = 1000,
    init = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_better_performance = 1
      vim.g.everforest_transparent_background = 2
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everforest",
    },
  },
}
