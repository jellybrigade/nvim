-- Fyler (file explorer)
vim.keymap.set("n", "<leader>e", ":Fyler kind=split_left<CR>", { desc = "Open Fyler" })

-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to down window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to up window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Clear search highlights
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- German keyboard lol
vim.keymap.set('', 'ö', '[')
vim.keymap.set('', 'ä', ']')
vim.keymap.set('', 'Ö', '{')
vim.keymap.set('', 'Ä', '}')
vim.keymap.set('', 'ü', ';')
vim.keymap.set('', 'Ü', ':')


-- Move selected lines up/down in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Keep cursor centered when scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Paste over visual selection without yanking the deleted text
vim.keymap.set('x', '<leader>p', '"_dP')

-- Delete to void register
vim.keymap.set('n', '<leader>d', '"_d')
vim.keymap.set('v', '<leader>d', '"_d')
