---
name: do
description: Add a feature to this nvim config the proper way — research .reference-projects first, then implement. Use when the user says "/do <feature>" or asks to add/build a new nvim feature/plugin.
---

# /do — add a feature to this nvim config

Args: free-text description of the feature/plugin to add (e.g. `/do autopairs`, `/do lazygit integration`).

Follow these steps in order. Do not skip straight to implementation.

## 1. Research `.reference-projects/`

Search all dirs under `.reference-projects/` for this feature or close equivalents
(grep plugin names, keywords, related keymaps). Source priority:

1. `.reference-projects/LazyVim-FULL` — the full LazyVim plugin distro. Primary/authoritative:
   its plugin configs, keybinds, and settings are the reference implementation to copy from.
2. `.reference-projects/nvim-kickstart` (teamlead's config) — secondary authoritative source.
   Defer to it for keymap/style choices where LazyVim-FULL doesn't cover something or where
   the teamlead made an explicit different choice worth following.

The rest (`ecosse3-nvim`, `jakobwesthoff-nvim-from-scratch`, `jakobwesthoff-nvim-original`,
`kickstart.nvim`, `nvim-craftzdog`, `nvim-jdhao`, `rafi-nvim`, `SeniorMars-nvim`) are
secondary — extra ideas only, not authoritative.

## 2. Check existing plugins

Grep `lua/plugins/*.lua` before writing any code, to avoid duplicating a plugin/mapping
that already exists and to keep new keymaps from colliding with existing `<leader>` groups.

## 3. Implement

Build the feature as a new `lua/plugins/<name>.lua` file (or edit an existing one if the
feature extends it), following this config's conventions: modular one-plugin-per-file,
`vim.lsp.config`/`vim.lsp.enable` native API for LSP (not `lspconfig.setup{}`), teamlead's
keymap/style choices where applicable. After writing, run a headless smoke test:

```
nvim --headless "+Lazy! sync" +qa
```

and verify the plugin loads with no errors (`require('<plugin>')` in a deferred headless
check if needed).

## 4. Commit

Always commit the change when done (see repo commit conventions).
