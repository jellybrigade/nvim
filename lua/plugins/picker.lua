-- Dirs never worth walking, even with `ignored = true` (which passes
-- --no-ignore to fd/rg and would otherwise descend into node_modules etc).
local exclude = {
  ".git",
  ".jj",
  ".svn",
  "node_modules",
  ".venv",
  "venv",
  "__pycache__",
  ".mypy_cache",
  ".pytest_cache",
  ".ruff_cache",
  ".cache",
  "target",
  "dist",
  "build",
  ".next",
  ".nuxt",
  ".turbo",
  ".terraform",
  "vendor",
  ".gradle",
  ".idea",
  ".DS_Store",
}

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = { hidden = true, ignored = true, exclude = exclude },
        grep = { hidden = true, ignored = true, exclude = exclude },
        grep_word = { hidden = true, ignored = true, exclude = exclude },
        explorer = { hidden = true, ignored = true, exclude = exclude },
      },
    },
  },
}
