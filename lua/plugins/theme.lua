return {
  {
    'jacoborus/tender.vim',
    lazy = false, -- Load immediately
    priority = 1000, -- Load before other plugins
    config = function()
      vim.cmd('colorscheme tender')
    end,
  },
}

