# docs.md — feature log

Lookup table for every feature built in this config: how it was implemented, which
`.reference-projects/` entry it came from, and its important keybinds. Read this before
adding anything new (see `.claude/skills/do/SKILL.md` for the `/do` workflow) — avoids
duplicate plugins and keymap collisions. Check `lua/plugins/which-key.lua` for the
current list of registered `<leader>` groups.

`.reference-projects/nvim-kickstart` (teamlead's config) and `.reference-projects/LazyVim`
are both primary/authoritative reference sources (equal priority); the rest are secondary,
ideas-only.

---

## Skeleton (options, keymaps, autocmds, lazy.nvim bootstrap)

**Reference:** `.reference-projects/nvim-kickstart` (teamlead's config), standard
kickstart.nvim skeleton pattern.

**Implementation:** `init.lua` sets `<leader>` to space, bootstraps lazy.nvim, requires
`config.options`/`config.keymaps`/`config.autocmds`/`config.lazy`. `lua/config/lazy.lua`
calls `require('lazy').setup()` importing `{ import = 'plugins' }`, so any `.lua` file
dropped in `lua/plugins/` is auto-loaded as a plugin spec — no manual registration needed.

**Keybinds:**
- `<Esc>` (normal) — clear search highlight
- `<leader>q` — diagnostic quickfix list
- `<Esc><Esc>` (terminal) — exit terminal mode
- `<C-h/j/k/l>` — window navigation
- `<leader>w` — write buffer
- `<leader><BS>` — close all other windows

---

## Colorscheme

**Reference:** none — picked independently (everforest, not in any reference project).

**Implementation:** `lua/plugins/colorscheme.lua` — `neanias/everforest-nvim`, medium
background, applied via `vim.cmd.colorscheme 'everforest'`.

**Keybinds:** none.

---

## Telescope (fuzzy picker)

**Reference:** `.reference-projects/nvim-kickstart`, standard kickstart telescope block.

**Implementation:** `lua/plugins/telescope.lua` — `nvim-telescope/telescope.nvim`
(branch `0.1.x`) + `telescope-fzf-native.nvim` (native sort, built via `make` if
available) + `telescope-ui-select.nvim` (dropdown theme for `vim.ui.select`).

**Keybinds** (all under which-key group `<leader>s` = "Search"):
- `<leader>sh` — help tags
- `<leader>sk` — keymaps
- `<leader>sf` — find files
- `<leader>sF` — find files, incl. hidden/gitignored
- `<leader>ss` — Telescope builtin picker select
- `<leader>sw` — grep current word
- `<leader>sg` — live grep
- `<leader>sd` — diagnostics
- `<leader>sr` — resume last search
- `<leader>s.` — recent files (oldfiles)
- `<leader><leader>` — find existing buffers
- `<leader>/` — fuzzy search current buffer
- `<leader>s/` — live grep in open files
- `<leader>sn` — find files in neovim config dir

---

## neo-tree (file explorer)

**Reference:** `.reference-projects/nvim-kickstart` convention (`\` as toggle key), else
generic neo-tree default setup.

**Implementation:** `lua/plugins/neo-tree.lua` — `nvim-neo-tree/neo-tree.nvim`,
dependencies `plenary.nvim`, `nvim-web-devicons`, `nui.nvim`. Lazy-loaded on `Neotree` cmd
or the `\` key.

**Keybinds:**
- `\` — reveal current file in tree / toggle
- `\` (inside neo-tree filesystem window) — close window

---

## lualine (statusline)

**Reference:** none specific — standard lualine setup, themed to match colorscheme.

**Implementation:** `lua/plugins/lualine.lua` — `nvim-lualine/lualine.nvim` themed to
`everforest`.

**Keybinds:** none (statusline only).

---

## which-key (keymap hints/groups)

**Reference:** `.reference-projects/nvim-kickstart` for base setup;
`.reference-projects/LazyVim`'s `lua/lazyvim/plugins/editor.lua` which-key spec for the
grouping convention (LazyVim groups every multi-key prefix, incl. non-`<leader>` ones
like `g` "goto", `[`/`]`, `z`) — copied that pattern for our own prefixes.

**Implementation:** `lua/plugins/which-key.lua` — `folke/which-key.nvim`, loaded on
`VimEnter`. Registers group labels for multi-key prefixes:
- `<leader>s` → "[S]earch"
- `<leader>h` → "Git [H]unk" (normal + visual mode)
- `<leader>t` → "[T]oggle"
- `<leader>b` → "[B]uffer" (covers `<leader>bd` dashboard)
- `g` → "[G]oto" (covers `gd`/`gr`/`gI`/`gD`)

Standalone single-key `<leader>` mappings (`c`, `d`, `D`, `f`, `q`, `r`, `w`) don't need
groups — which-key labels them individually from their `desc`.

**Keybinds:** none of its own — provides the popup UI for other plugins' keymaps.

---

## Treesitter

**Reference:** `.reference-projects/nvim-kickstart` for the general approach; had to
diverge on API — teamlead's config runs on a newer nvim that supports
nvim-treesitter's `main` branch (needs `vim.list.unique`, nvim 0.12+). Our nvim is 0.11.6,
so used the `master` (legacy) branch with the old `require('nvim-treesitter.configs').setup{}`
API instead.

**Implementation:** `lua/plugins/treesitter.lua` — `nvim-treesitter/nvim-treesitter`,
branch `master`. `ensure_installed`: bash, json, yaml, lua, javascript, typescript, tsx,
vue, markdown (pulls in `markdown_inline` automatically as a dependency).
`highlight.enable = true`, `indent.enable = true`.

**Keybinds:** none directly (drives highlighting/indent for all filetypes).

---

## LSP

**Reference:** `.reference-projects/nvim-kickstart` (teamlead's config) — primary source
for server list, native `vim.lsp.config`/`vim.lsp.enable` API (not
`lspconfig.setup{}` calls), capabilities setup, and the `LspAttach` autocmd keymap block.

**Implementation:** `lua/plugins/lsp.lua` — `neovim/nvim-lspconfig` +
`williamboman/mason.nvim` + `mason-lspconfig.nvim` + `mason-tool-installer.nvim` +
`j-hui/fidget.nvim` (LSP progress UI) + `hrsh7th/cmp-nvim-lsp` (capabilities).

Servers: `ts_ls`, `vue_ls`, `eslint`, `bashls`, `jsonls`, `yamlls`, `lua_ls`,
`gitlab_ci_ls`.

Key decisions:
- **vue_ls hybrid mode**: `ts_ls` loads `@vue/typescript-plugin` from vue_ls's mason
  install dir via `init_options.plugins`, with `filetypes` extended to include `vue` —
  single `ts_ls` instance understands `.vue` files; `vue_ls` itself only handles
  template-specific features. Both attach together on `.vue` files.
- **gitlab_ci_ls filetype fix**: lspconfig's default `filetypes = {'yaml.gitlab'}`
  requires a compound filetype nothing sets, so it would never attach on real
  `.gitlab-ci.yml` files. Overrode to `filetypes = { 'yaml' }`, matching teamlead's
  config — verified `yamlls` + `gitlab_ci_ls` both attach on a `.gitlab-ci.yml` buffer.
- **`mason-lspconfig.setup{ automatic_enable = false }`**: default `true` auto-enables
  *every* mason-installed server with an lspconfig entry, including stray leftovers from
  an unrelated prior config in the shared `~/.local/share/nvim/mason` dir (caused an
  unwanted `vtsls` client to attach). We already explicitly `vim.lsp.enable()` our own
  server list, so automatic enable is redundant and unsafe here.

**Keybinds** (wired via `LspAttach` autocmd, telescope-backed where applicable):
- `gd` — goto definition
- `gr` — goto references
- `gI` — goto implementation
- `<leader>D` — type definition
- `<leader>ds` — document symbols
- `<leader>ws` — workspace symbols (dynamic)
- `<leader>rn` — rename
- `<leader>ca` (normal + visual) — code action
- `gD` — goto declaration
- `<leader>th` — toggle inlay hints (only mapped if server supports it)
- Document-highlight on cursor hold (auto, no keymap)

Fix-on-save: `EslintFixAll` runs on `BufWritePre` for `*.js`, `*.ts`, `*.vue` when the
`eslint` client is attached.

---

## Formatting (conform.nvim)

**Reference:** none directly — target stack (stylua/prettier) was decided in `plan.md`;
`stevearc/conform.nvim` chosen as the standard modern formatter plugin (kickstart.nvim
uses the same).

**Implementation:** `lua/plugins/conform.lua` — `stevearc/conform.nvim`, lazy-loaded on
`BufWritePre`. `format_on_save` with `lsp_format = 'fallback'` (use LSP formatting only
if no dedicated formatter is configured for the filetype). Formatters:
`lua` → stylua, `javascript`/`typescript`/`javascriptreact`/`typescriptreact`/`vue`/
`json`/`yaml` → prettier. Both `stylua` and `prettier` are installed via
`mason-tool-installer`'s `ensure_installed` list in `lua/plugins/lsp.lua`.

**Keybinds:**
- `<leader>f` (normal + visual) — format buffer manually
- Format-on-save is automatic, no keymap

---

## Completion (nvim-cmp)

**Reference:** `.reference-projects/nvim-kickstart` — copied the classic nvim-cmp setup
(mappings, sources) verbatim, minus teamlead's custom `lazydev`/`twbulk` sources which
are irrelevant to our stack.

**Implementation:** `lua/plugins/completion.lua` — `hrsh7th/nvim-cmp`, lazy-loaded on
`InsertEnter`. Snippet engine: `L3MON4D3/LuaSnip` (+ `cmp_luasnip` source). Sources:
`nvim_lsp`, `luasnip`, `path`.

**Keybinds** (insert mode):
- `<C-j>` / `<C-k>` — select next/prev completion item
- `<C-b>` / `<C-f>` — scroll completion docs
- `<Tab>` / `<CR>` — confirm selected item
- `<C-Space>` — manually trigger completion
- `<C-l>` — expand/jump forward in snippet
- `<C-h>` — jump backward in snippet

---

## Git signs (gitsigns.nvim)

**Reference:** `.reference-projects/nvim-kickstart` — copied verbatim (signs config,
`current_line_blame`, full keymap block).

**Implementation:** `lua/plugins/gitsigns.lua` — `lewis6991/gitsigns.nvim`. Custom gutter
sign glyphs (`+`/`~`/`-`/`‾`/`~`), `current_line_blame = true`. which-key group
`<leader>h` = "Git [H]unk" registered in `lua/plugins/which-key.lua`.

**Keybinds** (buffer-local, set on `on_attach`):
- `<leader>hn` / `<leader>hp` — next/prev hunk (falls back to `]c`/`[c` in diff mode)
- `<leader>hs` / `<leader>hr` (normal + visual) — stage/reset hunk
- `<leader>hS` / `<leader>hR` — stage/reset entire buffer
- `<leader>hv` — preview hunk
- `<leader>hi` — inline hunk preview
- `<leader>hb` — blame line (full)
- `<leader>hd` — diff this
- `<leader>hD` — diff against last commit
- `<leader>hQ` / `<leader>hq` — hunk quickfix list (all repo / current buffer)
- `<leader>tb` — toggle current-line blame
- `<leader>tw` — toggle word diff
- `ih` (operator-pending + visual) — hunk text object

---

## German keyboard bracket remap (ö/ä → [ ])

**Reference:** `.reference-projects/jakobwesthoff-nvim-from-scratch` — used its
`ü` → `[` `langmap` + `keymap.set` trick as the pattern, extended to `ö`/`ä` since
those sit right next to Enter and are easier to reach than `[`/`]` (which need AltGr
on a German layout).

**Implementation:** `vim.opt.langmap = 'ö[,ä]'` in `lua/config/options.lua` (covers
most contexts); plain `langmap` misses some cases, so also direct normal-mode remaps
in `lua/config/keymaps.lua`: `vim.keymap.set('n', 'ö', '[', {remap=true})` and same
for `ä` → `]`.

**Keybinds:**
- `ö` — acts as `[` (normal mode)
- `ä` — acts as `]` (normal mode)

---

## LazyVim-inspired keymaps

**Reference:** `.reference-projects/LazyVim/lua/lazyvim/config/keymaps.lua` — reviewed
every keymap there against our own full keymap set and ported the ones that (a) don't
need `snacks.nvim` pickers/terminal/bufdelete (we only enabled snacks' `dashboard`
module, see below) and (b) don't collide with existing single-key `<leader>` mappings
(`c`, `f`, `q`, `r`, `w` stay as-is — e.g. LazyVim's `<leader>f` "file/find" group is
skipped since ours is already `[F]ormat`).

**Implementation:** `lua/config/keymaps.lua`, appended section. Plain vimscript/Lua,
no new plugins:
- Display-line-aware `j`/`k`/`<Down>`/`<Up>` (count-aware, falls back to real
  line motion when a count is given)
- `<C-Up/Down/Left/Right>` — resize window
- `<A-j>`/`<A-k>` (normal/insert/visual) — move line/selection up/down
- `<`/`>` in visual mode keep the selection (`gv`) after indenting
- Insert-mode undo breakpoints on `,` `.` `;`
- `n`/`N` always search forward/backward regardless of `/` vs `?`, and open folds
  (`zv`)
- `<C-s>` (normal/insert/visual) — save file, alongside existing `<leader>w`
- Buffers: `<S-h>`/`<S-l>` and `[b`/`]b` prev/next buffer, `<leader>bb` switch to
  alternate buffer, `<leader>bd` delete buffer while preserving window layout
  (no `snacks.bufdelete`, so hand-rolled: switch to next buffer first, `enew` if
  none, then `bdelete` the old one)
- Diagnostics: `]d`/`[d` next/prev, `]e`/`[e` next/prev error, `]w`/`[w`
  next/prev warning (uses `vim.diagnostic.jump`, our nvim is 0.11+ so the newer
  API is available, unlike the deprecated `goto_next`/`goto_prev`)
- Quickfix/loclist: `]q`/`[q` navigate quickfix, `<leader>xq`/`<leader>xl` toggle
  quickfix/location list window
- Extra toggles alongside gitsigns' `<leader>tb`/`<leader>tw`: `<leader>ts` spell,
  `<leader>tW` wrap (capital `W` — lowercase `tw` was already taken by git word-diff
  toggle)
- `<leader>l` — open the Lazy plugin manager UI

**Deliberately skipped** (need `snacks.nvim` modules we disabled, or would
collide with our `nvim-kickstart`-derived single-key leader mappings):
zen/zoom windows, floating terminal, `lazygit`/git browse pickers, tab keymaps,
`<leader>u` "ui" toggle group (folded into our existing `<leader>t` group instead),
`gco`/`gcO` comment keymaps (no comment plugin installed).

**Keybinds:** see list above; which-key groups added for `<leader>b` "[B]uffer",
`<leader>x` "[X] Diagnostics/Quickfix", `[` "Prev", `]` "Next" in
`lua/plugins/which-key.lua`.

---

## Dashboard (start screen)

**Reference:** `.reference-projects/nvim-kickstart` (teamlead's config) for the choice of
plugin (`folke/snacks.nvim`) and the ASCII header/preset pattern. Teamlead's config wires
snacks as a full IDE layer (picker, explorer, notifier, etc.) — we only enabled the
`dashboard` module since telescope/neo-tree/lualine already cover those roles; every other
snacks module is explicitly `enabled = false` to avoid duplicate functionality.

**Implementation:** `lua/plugins/dashboard.lua` — `folke/snacks.nvim`, `lazy = false`,
only `dashboard.enabled = true`. Custom key items on the dashboard buffer call our
existing `:Telescope` commands (not `Snacks.picker`, since telescope is our picker).
Sections: `header`, `keys`, `startup` (recently-lazy-loaded plugin count/time). Shown
automatically on `VimEnter` when opening nvim with no file args. Verified via
`nvim --headless "+Lazy! sync" +qa` — no load errors (dashboard itself is a no-op in
headless mode by snacks' own design, since it checks `nvim_list_uis()`).

**Keybinds:**
- `<leader>bd` — reopen dashboard in current buffer (`Snacks.dashboard()`)
- On the dashboard buffer itself: `f` find file, `n` new file, `g` find text (grep),
  `r` recent files, `c` find file in config dir, `L` open Lazy, `q` quit
