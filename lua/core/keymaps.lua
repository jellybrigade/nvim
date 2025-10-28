-- General options
-- Leader key assumed to be space

-- === FILE MANAGEMENT ===
-- File explorer
vim.keymap.set("n", "<leader>e", ":Fyler kind=split_left<CR>", { desc = "Open Fyler (file explorer)" })

-- === WINDOW NAVIGATION ===
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Jump directly to window by number (1–6)
for i = 1, 6 do
  local keys = "<Leader>" .. i
  local target = i .. "<C-W>w"
  vim.keymap.set("n", keys, target, { desc = "Jump to window " .. i })
end

-- === SEARCH & HIGHLIGHTING ===
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- === TEXT MOVEMENT ===
-- Move selected lines up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Keep cursor centered while scrolling or navigating search results
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Keep selection when indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and keep selection" })

-- === EDITING ===
-- Paste over selection without overwriting default register
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste over selection without yanking" })

-- Delete to void register
vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete without yanking" })
vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete selection without yanking" })

-- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

-- === MISC ===
-- Quickly save and quit
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Write (save) file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit window" })

-- Diagnostic floating window (if using LSP)
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostics in float" })
