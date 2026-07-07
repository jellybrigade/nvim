# ideas.md — feature ideas from reference projects

Not-yet-built plugin/feature ideas found in `.reference-projects/`. Not authoritative,
not a commitment — a scratch list to pull from for future `/do` runs. Cross-check
against `docs.md` before implementing (avoid duplicates as new features land).

---

## Comments

- `numToStr/Comment.nvim` — `gcc`/`gc` line/block comment toggle — ecosse3-nvim, rafi-nvim
- `folke/ts-comments.nvim` — treesitter-aware native commentstring commenting (LazyVim's
  modern replacement for Comment.nvim) — LazyVim, SeniorMars-nvim
- `JoosepAlviste/nvim-ts-context-commentstring` — correct commentstring in embedded
  languages (JSX, Vue, etc.) — ecosse3-nvim, LazyVim, rafi-nvim

## Autopairs

- `windwp/nvim-autopairs` — auto-close brackets/quotes — jakobwesthoff-nvim-original,
  nvim-jdhao, SeniorMars-nvim
- `windwp/nvim-ts-autotag` — auto-close/rename HTML/JSX tags via treesitter —
  ecosse3-nvim, jakobwesthoff-nvim-original, LazyVim

## Surround

- `kylechui/nvim-surround` — add/change/delete surrounding pairs (quotes, brackets,
  tags) — ecosse3-nvim, SeniorMars-nvim
- `echasnovski/mini.surround` — same, via mini.nvim family — LazyVim
- `machakann/vim-sandwich` — alternative surround implementation — nvim-jdhao, rafi-nvim

## Git UI

- `Snacks.lazygit()` — floating lazygit terminal via snacks.nvim (already installed for
  dashboard, just needs the module enabled) — ecosse3-nvim, nvim-kickstart
- `NeogitOrg/neogit` — full magit-style git porcelain UI — nvim-jdhao, SeniorMars-nvim
- `tpope/vim-fugitive` — classic git commands/status/blame — nvim-jdhao, rafi-nvim,
  SeniorMars-nvim
- `sindrets/diffview.nvim` (or `dlyongemallo` fork) — side-by-side diff view + file
  history browser — nvim-jdhao, rafi-nvim, ecosse3-nvim
- `FabijanZulj/blame.nvim` — inline git blame viewer — ecosse3-nvim, rafi-nvim
- `ruifm/gitlinker.nvim` (or `linrongbin16` fork) — generate/copy permalink to git host
  for current line — ecosse3-nvim, nvim-jdhao
- `NeilGirdhar/git-conflict.nvim` — highlight/navigate/resolve merge conflict markers —
  ecosse3-nvim

## DAP / Debugging

- `mfussenegger/nvim-dap` — core DAP client — kickstart.nvim, nvim-kickstart,
  ecosse3-nvim, LazyVim
- `rcarriga/nvim-dap-ui` — scopes/stacks/breakpoints/repl panels — ecosse3-nvim, LazyVim
- `theHamsta/nvim-dap-virtual-text` — inline variable values while debugging —
  ecosse3-nvim, LazyVim
- `mason-nvim-dap` — mason-managed debug adapters — kickstart.nvim, nvim-kickstart

## Test Runner

- `nvim-neotest/neotest` (+ `nvim-nio`, language adapters e.g. `neotest-jest`,
  `neotest-python`) — run/inspect tests in-editor with UI panel — ecosse3-nvim, LazyVim

## UI Polish / Diagnostics

- `folke/trouble.nvim` — pretty diagnostics/quickfix/loclist/references list —
  rafi-nvim, LazyVim
- `folke/todo-comments.nvim` — highlight/list TODO/FIXME/HACK, integrates with
  trouble/telescope — ecosse3-nvim, jakobwesthoff-nvim-original, LazyVim, SeniorMars-nvim
- `RRethy/vim-illuminate` — highlight other usages of word under cursor — nvim-jdhao,
  LazyVim, rafi-nvim
- `lukas-reineke/indent-blankline.nvim` (or `mini.indentscope`) — indent guides/scope
  highlight — nvim-jdhao, kickstart.nvim, nvim-kickstart, LazyVim, rafi-nvim
- `folke/noice.nvim` (+ `rcarriga/nvim-notify`) — replaces cmdline/messages/popupmenu
  UI, nicer notifications — ecosse3-nvim, nvim-craftzdog, nvim-jdhao, nvim-kickstart,
  rafi-nvim, LazyVim
- `akinsho/bufferline.nvim` — tabline showing open buffers as tabs — ecosse3-nvim,
  nvim-craftzdog, nvim-jdhao, rafi-nvim, LazyVim
- `kevinhwang91/nvim-ufo` (+ `promise-async`) — better code folding w/ preview —
  ecosse3-nvim, nvim-jdhao, rafi-nvim
- `catgoose/nvim-colorizer.lua` (or `nvim-highlight-colors`) — inline highlight of
  hex/rgb color codes — nvim-jdhao, ecosse3-nvim, jakobwesthoff-nvim-original
- `folke/zen-mode.nvim` — distraction-free centered mode — nvim-craftzdog
- `kevinhwang91/nvim-bqf` — better quickfix window (preview, fzf filter) — ecosse3-nvim,
  nvim-jdhao, rafi-nvim, SeniorMars-nvim

## Session Management

- `folke/persistence.nvim` — auto save/restore session per project dir, minimal —
  rafi-nvim, LazyVim
- `rmagatti/auto-session` — auto session save/restore, git-branch-aware —
  SeniorMars-nvim
- `Shatur/neovim-session-manager` — session save/restore w/ autoload modes —
  ecosse3-nvim

## Navigation / Motion

- `folke/flash.nvim` — enhanced f/t + jump-to-anywhere label motions — ecosse3-nvim,
  nvim-craftzdog, LazyVim
- `ThePrimeagen/harpoon` — quick-mark and jump between frequently used files —
  ecosse3-nvim, LazyVim
- `chentoast/marks.nvim` — visualize/manage vim marks in sign column — ecosse3-nvim,
  rafi-nvim

## Misc

- `stevearc/oil.nvim` — edit filesystem as a normal buffer (complement/alt to neo-tree)
  — jakobwesthoff-nvim-from-scratch, jakobwesthoff-nvim-original
- `mbbill/undotree` — visualize/navigate undo history tree — SeniorMars-nvim
- `nmac427/guess-indent.nvim` (or `tpope/vim-sleuth`) — auto-detect indentation per
  file — SeniorMars-nvim, jakobwesthoff-nvim-from-scratch/original
- `gbprod/yanky.nvim` — yank history ring + picker to cycle previous yanks —
  nvim-jdhao, LazyVim
- `MagicDuck/grug-far.nvim` — project-wide find-and-replace UI — ecosse3-nvim, LazyVim

---

Note: no reference project uses a dedicated `toggleterm.nvim`-style plugin — floating
terminal needs (lazygit, scratch shells) are handled via `Snacks.terminal()`/
`Snacks.lazygit()`, which we already have installed (dashboard module) — enabling that
module is the natural path if floating terminal is wanted.
