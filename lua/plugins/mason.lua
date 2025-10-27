-- ~/.config/nvim/lua/plugins/mason.lua

return {
  -- Mason, the tool manager
  {
    'williamboman/mason.nvim',
    config = function()
      -- This is where you install non-LSP tools.
      -- Mason's own ensure_installed handles linters, formatters, DAPs, etc.
      require('mason').setup({
        ensure_installed = {
          -- Linters/Formatters
          'eslint_d', -- Fast ESLint daemon
        },
      })
    end,
  },

  -- Mason's bridge to nvim-lspconfig
  {
    'williamboman/mason-lspconfig.nvim',
    -- Ensure mason.nvim is loaded first
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      -- This list should ONLY contain LSP server names recognized by lspconfig
      ensure_installed = {
        -- LSP Servers
        'ts_ls',          -- TypeScript/JavaScript
        'html',           -- HTML
        'cssls',          -- CSS
        'jsonls',         -- JSON
        'eslint',         -- ESLint Language Server
        'vuels',          -- Vue Language Server
        'tailwindcss',    -- Tailwind CSS LSP
        'yamlls',         -- YAML LSP
        'graphql',        -- GraphQL LSP (The name in lspconfig is 'graphql')
      },
      automatic_installation = true,
    },
  },
}

