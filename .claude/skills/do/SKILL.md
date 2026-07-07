---
name: do
description: Add a feature to this nvim config the proper way — research .reference-projects first, check docs.md, implement, then document. Use when the user says "/do <feature>" or asks to add/build a new nvim feature/plugin.
---

# /do — add a feature to this nvim config

Args: free-text description of the feature/plugin to add (e.g. `/do autopairs`, `/do lazygit integration`).

Follow these steps in order. Do not skip straight to implementation.

## 1. Research `.reference-projects/`

Search all dirs under `.reference-projects/` for this feature or close equivalents
(grep plugin names, keywords, related keymaps). Per `plan.md`'s source priority:
`.reference-projects/nvim-kickstart` (teamlead's config) and `.reference-projects/LazyVim`
are both primary/authoritative sources — defer to their conventions, keymap style, and
plugin choice whenever they conflict with the other reference projects. The rest
(`ecosse3-nvim`, `jakobwesthoff-nvim-from-scratch`, `jakobwesthoff-nvim-original`,
`kickstart.nvim`, `nvim-craftzdog`, `nvim-jdhao`, `rafi-nvim`, `SeniorMars-nvim`) are
secondary — extra ideas only, not authoritative.

## 2. Read `docs.md`

Read `docs.md` at the repo root before writing any code. It documents every feature
already built: how, why, which reference project it came from, and its keybinds. This
avoids duplicating a plugin/mapping that already exists and keeps new keymaps from
colliding with existing `<leader>` groups (see `lua/plugins/which-key.lua` for
registered groups).

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

## 4. Document in `docs.md`

Append an entry to `docs.md` for the feature, in the same format as existing entries:
- Feature name
- Which reference project it was based on (or "none — built from scratch")
- How it was implemented (brief — plugin(s) used, key config decisions)
- Important keybinds

Keep entries terse — this is a lookup table for future work, not prose documentation.

## 5. Commit

After docs.md updated, commit all changes (new/edited plugin file + docs.md) with a
concise commit message describing the feature added, then push to remote. Always
commit and push — do not leave the work uncommitted or unpushed.
