-- Fix for tender.vim colorscheme with modern plugins

-- Snacks Picker highlights
vim.cmd([[highlight SnacksPickerNormal guibg=#282828]])
vim.cmd([[highlight SnacksPickerTitle guibg=#4e4e4e guifg=#f4f4f4]])
vim.cmd([[highlight SnacksPickerBorder guibg=#282828 guifg=#4e4e4e]])
vim.cmd([[highlight SnacksPickerPrompt guibg=#282828 guifg=#f4f4f4]])
vim.cmd([[highlight SnacksPickerMatch guifg=#b3deef]])
vim.cmd([[highlight SnacksPickerList guibg=#282828]])
vim.cmd([[highlight SnacksPickerDir guifg=#7ab0d3]])

-- Fix for the picker preview window and its border
vim.cmd([[highlight SnacksPickerPreview guibg=#1c1c1c]])
vim.cmd([[highlight SnacksPickerPreviewBorder guibg=#282828 guifg=#4e4e4e]])

-- Fix for the picker input/search box and its border
vim.cmd([[highlight SnacksPickerInput guibg=#333333 guifg=#f4f4f4]])
vim.cmd([[highlight SnacksPickerInputBorder guibg=#282828 guifg=#4e4e4e]])

-- Which-key highlights
vim.cmd([[highlight WhichKey guifg=#f4f4f4]])
vim.cmd([[highlight WhichKeyGroup guifg=#7ab0d3]])
vim.cmd([[highlight WhichKeySeparator guifg=#b3deef]])
vim.cmd([[highlight WhichKeyDesc guifg=#f4f4f4]])

-- Fix for the which-key floating window background with a lighter gray for clarity
vim.cmd([[highlight NormalFloat guibg=#3c3c3c]])
vim.cmd([[highlight FloatBorder guifg=#4e4e4e]])
