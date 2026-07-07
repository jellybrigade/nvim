# nvim config build plan

## Decisions

- Plugin manager: lazy.nvim
- Language: Lua only
- Structure: modular multi-file (LazyVim-esque) — `lua/config/*`, `lua/plugins/*.lua`
- Stack focus (intern, TS/JS-centric): TypeScript/JavaScript, Vue, bash, json, yaml, lua, GitLab CI

## Reference source priority

- **Primary source: `.reference-projects/nvim-kickstart`** — teamlead's own config. Defer
  to this for conventions, keymap style, LSP/plugin choices whenever it conflicts with
  the other refs.
- **Secondary sources (all others)** — used only for extra ideas/patterns, not authoritative:
  `ecosse3-nvim`, `jakobwesthoff-nvim-from-scratch`, `jakobwesthoff-nvim-original`,
  `kickstart.nvim`, `nvim-craftzdog`, `nvim-jdhao`, `rafi-nvim`, `SeniorMars-nvim`

## Reference: teamlead's config (`.reference-projects/nvim-kickstart`)

Based on kickstart.nvim, extended. Verified safe (no malicious code — surfingkeys
websocket server is a legit firenvim-derived browser bridge, binds 127.0.0.1 only).

Relevant findings:
- LSP servers enabled: `ts_ls`, `eslint`, `bashls`, `jsonls`, `yamlls`, `gitlab_ci_ls`, `lua_ls`
  (also clangd, java — irrelevant to us, teamlead does broader work)
- No dedicated Vue LSP (`vue_ls`/volar) configured, but:
  - treesitter parser `vue` installed
  - `EslintFixAll` autocmd runs on `BufWritePre` for `*.js, *.ts, *.vue`
- Formatting: conform.nvim, stylua for lua
- Plugin manager: lazy.nvim, mason.nvim + mason-lspconfig + mason-tool-installer for LSP/tool install
- Completion: nvim-cmp + cmp_nvim_lsp
- Inlay hints toggle keymap (`<leader>th`) when server supports it
- Highlight-on-yank, LspAttach/LspDetach document-highlight autocmds
- DAP (nvim-dap + dap-go + java-dap) — irrelevant, skipping
- Custom notetaking layer (obsidian.nvim, `*.collector.yml` autocmd) — irrelevant, skipping

## Our target stack (final)

LSP servers: `ts_ls`, `vue_ls` (Volar, hybrid mode with `ts_ls`), `eslint`, `bashls`,
`jsonls`, `yamlls`, `lua_ls`, `gitlab_ci_ls`

Formatters (conform.nvim): stylua (lua), prettier (ts/js/vue/json/yaml)
Fix-on-save: `EslintFixAll` autocmd for `*.js, *.ts, *.vue` (matches teamlead pattern)

## Build steps

1. Skeleton — `init.lua` (leader keys, lazy.nvim bootstrap, requires) +
   `lua/config/{options,keymaps,autocmds}.lua`
2. Plugin manager — lazy.nvim bootstrap + `lua/plugins/init.lua` auto-importing
   `lua/plugins/*.lua`
3. Core UX — colorscheme, telescope (picker), neo-tree, lualine, which-key
4. Treesitter — parsers: bash, json, yaml, lua, javascript, typescript, tsx, vue, markdown
5. LSP — mason.nvim + mason-lspconfig, servers listed above
6. Formatting — conform.nvim + stylua/prettier, eslint fix-on-save autocmd
7. Completion — nvim-cmp or blink.cmp + LuaSnip
8. Git — gitsigns.nvim
9. Polish — which-key groups, keymap cheatsheet, healthcheck pass

## Status

Step 1 (skeleton) done: `init.lua`, `lua/config/{options,keymaps,autocmds,lazy}.lua`,
`lua/plugins/init.lua` placeholder. lazy.nvim bootstraps clean (headless smoke test ok).
Step 2 (plugin manager) effectively done as part of step 1 — `lua/config/lazy.lua`
auto-imports `lua/plugins/*.lua`.

Step 3 (core UX) done: `lua/plugins/{colorscheme,telescope,neo-tree,lualine,which-key}.lua`.
Colorscheme: everforest (neanias/everforest-nvim), medium background. Telescope w/
fzf-native + ui-select, standard kickstart keymaps (`<leader>sf/sg/sh/...`). neo-tree on
`\`. lualine themed to everforest. which-key groups for `<leader>s/h/t`. `Lazy! sync`
ran headless clean, no errors, colorscheme applies.

Step 4 (treesitter) done: `lua/plugins/treesitter.lua`, branch `master` (nvim-treesitter
`main` branch needs nvim 0.12's `vim.list.unique`, incompatible w/ our nvim 0.11.6 — used
`master`/legacy `configs.setup` API instead). Parsers: bash, json, yaml, lua, javascript,
typescript, tsx, vue, markdown (markdown_inline pulled in automatically as markdown's
dependency). All installed clean via `:TSInstallInfo`, no startup errors.

Step 5 (LSP) done: `lua/plugins/lsp.lua`. mason.nvim + mason-lspconfig +
mason-tool-installer, native nvim 0.11 `vim.lsp.config`/`vim.lsp.enable` API (not
`lspconfig.setup{}` calls) — matches teamlead's convention. Servers: ts_ls, vue_ls,
eslint, bashls, jsonls, yamlls, lua_ls, gitlab_ci_ls, all installed + verified attaching.

vue_ls hybrid mode: ts_ls loads `@vue/typescript-plugin` from vue_ls's mason install dir
via `init_options.plugins`, filetypes extended to include `vue`; vue_ls handles
template-specific features. Verified both `ts_ls` + `vue_ls` attach on a `.vue` file,
`ts_ls` alone on a `.ts` file.

Gotcha found + fixed: `mason-lspconfig.setup` defaults `automatic_enable = true`, which
auto-enables *every* mason-installed server with an lspconfig entry — including stray
leftovers in the shared `~/.local/share/nvim/mason` dir from an unrelated prior config on
this machine (a `vtsls` client was attaching unexpectedly). Set `automatic_enable = false`
since we already explicitly `vim.lsp.enable()` our own server list.

LspAttach autocmd wires: telescope-backed gd/gr/gI/<leader>D/ds/ws, rename, code actions,
document-highlight, inlay-hint toggle (`<leader>th`). Eslint fix-on-save autocmd for
`*.js`/`*.ts`/`*.vue` per plan's target stack.

Step 6 (formatting) done: `lua/plugins/conform.lua` — conform.nvim, format-on-save
(`lsp_format = 'fallback'`), `<leader>f` manual format keymap. stylua for lua, prettier
for js/ts/jsx/tsx/vue/json/yaml. `prettier` added to lsp.lua's mason-tool-installer
`ensure_installed` list (stylua was already there). `Lazy! sync` + `MasonToolsInstallSync`
both clean, manual `require('conform').format{}` call on a lua buffer ran with no errors.

Step 7 (completion) done: `lua/plugins/completion.lua` — nvim-cmp (per teamlead convention)
+ LuaSnip, cmp_luasnip, cmp-nvim-lsp, cmp-path. Keymaps match teamlead: C-j/C-k select,
C-b/C-f scroll docs, Tab/CR confirm, C-Space trigger, C-l/C-h snippet jump. Skipped
teamlead's lazydev/twbulk sources (irrelevant custom stuff). `Lazy! sync` clean,
`require('cmp')`/`require('luasnip')` load with no errors.

Step 8 (git) done: `lua/plugins/gitsigns.lua`, copied verbatim from teamlead's config —
signs, current_line_blame, full hunk nav/stage/reset/preview/blame/diff keymaps under
`<leader>h`, toggles under `<leader>t`, `ih` hunk text object. which-key group for
`<leader>h` was already registered in step 3. `Lazy! sync` clean, `require('gitsigns')`
loads with no errors.

Step 9 (polish) done:
- `:checkhealth` full sweep run. Only errors found: latex/python/tmux treesitter query
  errors — parsers not in our target list, irrelevant, ignored.
- Found + fixed real gap: `gitlab_ci_ls`'s lspconfig default `filetypes = {'yaml.gitlab'}`
  requires a compound filetype we never set, so it would never attach on real
  `.gitlab-ci.yml` files. Matched teamlead's override in lsp.lua's `servers.gitlab_ci_ls`:
  `filetypes = { 'yaml' }`. Verified both `yamlls` + `gitlab_ci_ls` attach on a
  `.gitlab-ci.yml` test buffer.
- Reviewed all `<leader>` keymaps across config: groups `s`/`h`/`t` (multi-key prefixes)
  already registered in which-key.lua from steps 3/8; remaining leader keys (`c`, `d`, `D`,
  `f`, `q`, `r`, `w`) are standalone single mappings, no group needed.
- `Lazy! sync`, `checkhealth lazy`, `checkhealth mason` all clean.

## Build complete

All 9 steps done. Config covers: lazy.nvim, telescope, neo-tree, lualine, which-key,
treesitter (bash/json/yaml/lua/js/ts/tsx/vue/markdown), full LSP stack (ts_ls+vue_ls
hybrid, eslint, bashls, jsonls, yamlls, lua_ls, gitlab_ci_ls) w/ fix-on-save, conform.nvim
formatting (stylua/prettier), nvim-cmp completion, gitsigns.
