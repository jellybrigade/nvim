return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    icons = {
      breadcrumb = '»',
      separator = '➜',
      group = '+',
    },
    spec = {
      -- Document your keybindings here
      { '<leader>f', group = '[F]ind' },
      { '<leader>a', group = '[H]arpoon' },
      { '<leader>w', group = '[W]orkspace' },
    },
  },
}

