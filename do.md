# Teamlead nvim config analysis

Source: `.reference-projects/nvim-kickstart` (customized fork of kickstart.nvim).
Base structure: monolithic `init.lua` (~1155 lines, options + full plugin spec) + `lua/keymaps.lua`, `lua/autocmds.lua`, `lua/lsp.lua`, `lua/theme.lua`, `lua/kickstart/plugins/*` (stock extras), `lua/custom/plugins/*` (personal plugins, auto-imported), `lua/custom/*` + `lua/custom/twbulk/*` (bespoke modules), `after/ftplugin/*`.

Large chunk of custom code = bespoke **taskwarrior bulk-editor DSL** ("twbulk") — very personal/Anexia-specific, not worth porting wholesale, but patterns reusable (buffer-local ftplugin keymaps, custom conform formatter, custom cmp source).

---

## 1. Core options (init.lua top)

- leader/localleader = `' '`
- `have_nerd_font = true`
- number + relativenumber on
- mouse `'a'`, showmode off
- clipboard NOT auto-synced (no `unnamedplus`) — deliberate, see clipboard section
- breakindent, undofile on
- ignorecase+smartcase
- signcolumn `'yes'`, updatetime 250, timeoutlen 300
- splitright+splitbelow
- listchars: `tab='» ', trail='·', nbsp='␣'`
- inccommand `'split'`
- cursorline on, scrolloff 10
- custom `vim.g.clipboard`: routes `"+` register through **CopyQ** CLI (`copyq add -` / `copyq read 0`) instead of OS clipboard/wl-copy/xclip, `cache_enabled=0`

## 2. Notable keymaps

- [] `-` → Oil (open parent dir as buffer)
- [] `&lt;leader&gt;&lt;BS&gt;` → `:only`
- `&lt;C-h/j/k/l&gt;` → window nav (already have via LazyVim default)
- [] `Q` → replay macro q (normal: `@qj`, visual: over range); `&lt;leader&gt;r` → start recording into q
- **Claude Code integration**: `&lt;leader&gt;cl` copies `@path#Lstart-Lend` (git-root relative) to clipboard for pasting into chat; `&lt;leader&gt;cp` copies absolute path
- Explicit clipboard escape hatches: `&lt;leader&gt;y/p/P` → `"+y/p/P` (since default paste isn't OS-synced)
- hop.nvim char-jump (already have via LazyVim default `flash.nvim`)
- [] substitute.nvim: `S/SS/S$` (operator/line/eol), integrated with yanky
- LSP-attach keymaps (already have via LazyVim default)
- gitsigns keymaps (already have via LazyVim default)
- [] yanky: remaps `y/p/P/gp/gP`, `&lt;c-p&gt;/&lt;c-n&gt;` cycle history, `&lt;leader&gt;p` opens history picker
- Snacks picker/toggle surface (already have via LazyVim default)
- [] grapple.nvim: `&lt;leader&gt;m` toggle tag, `&lt;leader&gt;G` tags window
- [] telescope-undo: `&lt;leader&gt;u` undo tree

## 3. Plugins (lazy.nvim)

Core: [] vim-sleuth (auto-detect indent style), [] vim-repeat (repeatable plugin commands). Rest already have via LazyVim default: gitsigns.nvim, hop.nvim-equivalent (flash.nvim), which-key.nvim, picker (snacks/telescope), lazydev.nvim, nvim-lspconfig + mason stack, conform.nvim, completion engine, todo-comments.nvim, mini.ai, nvim-treesitter.

Kickstart extras: nvim-autopairs, neo-tree.nvim, gitsigns config (already have equivalents via LazyVim default). `debug.lua` (dap) and `indent_line.lua` present but **not required** — dead/inactive code, don't copy.

- [] nvim-lint (markdownlint)

git_browse.nvim (blame — already have via LazyVim default gitsigns `<leader>ghb`/`ghB`), catppuccin (not applicable, you use everforest), noice.nvim (already have via LazyVim default), obsidian.nvim (not applicable, see ideas.md), smart-open.nvim (frecency finder — already have via LazyVim default picker), snacks.nvim (already have via LazyVim default).

- [] img-clip.nvim (paste image — note: **keymap `&lt;leader&gt;P` collides** with global clipboard-paste map, needs remap)
- [] nvim-java+jdtls (full java stack)
- [] vim-visual-multi (multicursor)

Note: tokyonight installed but unused — `theme.lua` overrides to catppuccin. Redundant fuzzy-finder stack (telescope + snacks both active).

## 4. LSP setup

- Uses modern `vim.lsp.config()`/`vim.lsp.enable()` API, not `lspconfig.setup{}`.
- Servers: `clangd`, `eslint`, `ts_ls`, `bashls`, `jsonls` (formatter enabled), `gitlab_ci_ls`, `yamlls`, `lua_ls` (`callSnippet='Replace'`). gopls/pyright/rust_analyzer left commented out.
- mason + mason-tool-installer ensure servers + `stylua` installed.
- `lsp.lua` separately configures `gitlab_ci_ls` (explicit cmd/filetypes/root_markers) and re-declares `eslint` with its own `LspAttach` → `EslintFixAll` on save — **overlaps** with a second blunt `autocmds.lua` rule that runs `EslintFixAll` on `BufWritePre` for `*.js/*.ts/*.vue` regardless of LSP attach. Redundant, pick one mechanism.
- conform.nvim: `lua`→stylua, `markdown`→prettier, custom `twbulk` formatter; LSP-fallback formatting on except c/cpp.
- Java gets fully separate LSP path via nvim-java, independent of main lspconfig block.
- Diagnostics explicitly disabled for markdown buffers (`FileType markdown` autocmd).

## 5. Autocmds

- `TextYankPost` → yank highlight (stock)
- [] `FileType markdown` → diagnostics off
- `BufWritePre *.js,*.ts,*.vue` → EslintFixAll (duplicates LspAttach-based eslint fix)
- `BufRead/BufNewFile *.prompteditor` → force filetype html
- twbulk module: strips `uuid:` tokens from yanked text, custom cmp source registration, note-existence sign refresh, subtask count virtual text

## 6. Other notable ideas worth stealing

- [] **mini.statusline** instead of lualine — lighter weight, one-line custom `section_location` format `%2l:%-2v`.
- [] **CopyQ-routed clipboard** instead of `unnamedplus` — deliberate choice to avoid every yank hitting system clipboard, with explicit `&lt;leader&gt;y/p/P` escape hatches.
- [] **Claude Code path-reference keymap** (`&lt;leader&gt;cl`/`cp`): copies `@relative/path#Lstart-Lend` git-root-relative reference for pasting into AI chat — directly useful, easy to port.
- Heavy Anexia/personal-environment coupling throughout (Obsidian vault paths, Jira URLs, i3/tmux spawning, timew) — not portable, skip.

## Known issues in teamlead's config (avoid copying these patterns)

1. Telescope and Snacks pickers both active with overlapping `&lt;leader&gt;s*` keys — pick one.
2. Eslint-fix-on-save implemented twice (LspAttach in `lsp.lua` + blunt autocmd in `autocmds.lua`).
3. `img-clip.nvim`'s `&lt;leader&gt;P` collides with global clipboard-paste `&lt;leader&gt;P`.
4. Dead plugin files present but not required (`debug.lua`, `indent_line.lua`).
5. tokyonight installed but unused (dead dependency).
