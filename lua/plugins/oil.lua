return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('oil').setup({
      -- Configuration goes here
      columns = { 'icon' },
      keymaps = {
        ['<C-h>'] = false,
        ['<M-h>'] = 'actions.select_split',
      },
      view_options = {
        show_hidden = true,
      },
    })

    -- Open parent directory
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
  end,
}

