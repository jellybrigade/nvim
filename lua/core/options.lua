vim.lsp.set_log_level("debug")

-- General options
vim.opt.mouse = "a"               -- Enable mouse support
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.swapfile = false          -- Disable swap files
vim.opt.undofile = true           -- Save undo history across sessions
vim.opt.scrolloff = 10            -- Keep lines visible above/below cursor
vim.opt.cmdheight = 0             -- Hide command line until needed
vim.opt.updatetime = 250          -- Faster completion and CursorHold updates

-- Appearance
vim.opt.number = true         -- Show absolute line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.signcolumn = "yes"    -- Always show the sign column
vim.opt.colorcolumn = "80"    -- Vertical marker at column 80
vim.opt.termguicolors = true  -- Enable 24-bit colors in terminal
vim.opt.cursorline = true     -- Highlight current line
vim.opt.breakindent = true    -- Wrapped lines visually indented

-- Indentation
vim.opt.tabstop = 2        -- Display width of a tab character
vim.opt.softtabstop = 2    -- Spaces per Tab press
vim.opt.shiftwidth = 2     -- Indent width for << and >>
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.smartindent = true -- Smart autoindent
vim.opt.autoindent = true  -- Keep indent from previous line
vim.opt.wrap = false       -- Disable line wrapping

-- Searching
vim.opt.ignorecase = true    -- Case-insensitive search
vim.opt.smartcase = true     -- Override if search has uppercase
vim.opt.inccommand = "split" -- Show live preview of substitutions

-- Splits
vim.opt.splitright = true -- Vertical splits open to the right
vim.opt.splitbelow = true -- Horizontal splits open below

-- Whitespace display
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Some keyboard mappings as I don't want to break my fingers, while typing on a "german" keyboard ;)
-- Essentially this remaps [] to öä with all its modifier key combinations as well
vim.opt.langmap = "ö[ä]"
vim.keymap.set({ "n", "v", "o" }, "ö", "[", { remap = true, desc = "German keyboard: map ö → [" })
vim.keymap.set({ "n", "v", "o" }, "ä", "]", { remap = true, desc = "German keyboard: map ä → ]" })

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = "Highlight text on yank",
})
