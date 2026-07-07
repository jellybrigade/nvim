-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Save shortcut
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = '[W]rite buffer' })

-- Close all other windows
vim.keymap.set('n', '<leader><BS>', '<cmd>only<CR>', { desc = 'Close all other windows' })

-- German keyboard: ö/ä -> [ ] (plain langmap doesn't cover all cases, see options.lua)
vim.keymap.set('n', 'ö', '[', { remap = true })
vim.keymap.set('n', 'ä', ']', { remap = true })

-- [[ LazyVim-inspired keymaps ]]
-- Ported selectively from .reference-projects/LazyVim/lua/lazyvim/config/keymaps.lua
-- (see docs.md for which ones and why).

-- Move by display line, not physical line, when wrapped (count-aware)
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Resize windows with Ctrl+arrows
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<CR>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<CR>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'Increase window width' })

-- Move lines up/down
vim.keymap.set('n', '<A-j>', "<cmd>execute 'move .+' . v:count1<CR>==", { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<CR>==", { desc = 'Move line up' })
vim.keymap.set('i', '<A-j>', '<Esc><cmd>m .+1<CR>==gi', { desc = 'Move line down' })
vim.keymap.set('i', '<A-k>', '<Esc><cmd>m .-2<CR>==gi', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv", { desc = 'Move selection up' })

-- Keep selection when indenting in visual mode
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

-- Undo break-points on punctuation (insert mode) so `u` doesn't undo whole sentences at once
vim.keymap.set('i', ',', ',<C-g>u')
vim.keymap.set('i', '.', '.<C-g>u')
vim.keymap.set('i', ';', ';<C-g>u')

-- n/N always search in the same direction, regardless of whether the last search was `/` or `?`
vim.keymap.set('n', 'n', "'Nn'[v:searchforward] . 'zv'", { expr = true, desc = 'Next search result' })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('n', 'N', "'nN'[v:searchforward] . 'zv'", { expr = true, desc = 'Prev search result' })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

-- Save with Ctrl+S, in addition to <leader>w
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR><Esc>', { desc = 'Save file' })

-- Buffers
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '[b', '<cmd>bprevious<CR>', { desc = 'Prev buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bb', '<cmd>e #<CR>', { desc = '[B]uffer switch to other' })
vim.keymap.set('n', '<leader>bd', function()
  local buf = vim.api.nvim_get_current_buf()
  vim.cmd 'bnext'
  if vim.api.nvim_get_current_buf() == buf then
    vim.cmd 'enew'
  end
  pcall(vim.cmd, 'bdelete ' .. buf)
end, { desc = '[B]uffer [D]elete (keep window layout)' })

-- Diagnostics navigation
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Next diagnostic' })
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Prev diagnostic' })
vim.keymap.set('n', ']e', function()
  vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR, float = true }
end, { desc = 'Next error' })
vim.keymap.set('n', '[e', function()
  vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR, float = true }
end, { desc = 'Prev error' })
vim.keymap.set('n', ']w', function()
  vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.WARN, float = true }
end, { desc = 'Next warning' })
vim.keymap.set('n', '[w', function()
  vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.WARN, float = true }
end, { desc = 'Prev warning' })

-- Quickfix / location list
vim.keymap.set('n', ']q', '<cmd>cnext<CR>', { desc = 'Next quickfix' })
vim.keymap.set('n', '[q', '<cmd>cprevious<CR>', { desc = 'Prev quickfix' })
vim.keymap.set('n', '<leader>xq', function()
  local winid = vim.fn.getqflist({ winid = 0 }).winid
  local ok, err = pcall(winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not ok then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = '[X] Toggle quickfix list' })
vim.keymap.set('n', '<leader>xl', function()
  local winid = vim.fn.getloclist(0, { winid = 0 }).winid
  local ok, err = pcall(winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not ok then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = '[X] Toggle location list' })

-- More toggles alongside the existing gitsigns ones (<leader>tb, <leader>tw)
vim.keymap.set('n', '<leader>ts', function()
  vim.o.spell = not vim.o.spell
end, { desc = '[T]oggle [S]pell' })
vim.keymap.set('n', '<leader>tW', function()
  vim.o.wrap = not vim.o.wrap
end, { desc = '[T]oggle [W]rap' })

-- Open the lazy.nvim plugin manager UI
vim.keymap.set('n', '<leader>l', '<cmd>Lazy<CR>', { desc = 'Open [L]azy' })
