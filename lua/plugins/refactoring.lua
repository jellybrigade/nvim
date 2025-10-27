return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('refactoring').setup()
  end,
  keys = {
    -- Example keybindings for refactoring
    { '<leader>rr', function() require('refactoring').refactor('Rename Variable') end, mode = { 'n', 'v' }, desc = '[R]efactor [R]ename' },
    { '<leader>ri', function() require('refactoring').refactor('Inline Variable') end, mode = { 'n', 'v' }, desc = '[R]efactor [I]nline Var' },
  },
}

