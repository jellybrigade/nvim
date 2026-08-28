-- Laravel Blade templates (*.blade.php).
--
-- Neovim 0.11 already detects the `blade` filetype, and nvim-ts-autotag already
-- aliases `blade` to `html`, so all that is missing is the parser itself.
-- nvim-treesitter's `blade` entry points at https://github.com/EmranMR/tree-sitter-blade
-- and ships highlights/indents/folds/injections queries for it.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- `blade` injections pull in html, php_only, javascript and bash, and
      -- blade has no `requires` entry, so list the php side explicitly.
      ensure_installed = { "blade", "php", "php_only" },
    },
  },

  -- Blade comments are `{{-- --}}`; without this the commentstring is empty.
  {
    "folke/ts-comments.nvim",
    optional = true,
    opts = {
      lang = {
        blade = "{{-- %s --}}",
      },
    },
  },
}
