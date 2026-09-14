-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.opt.langmap = "ö[ä]"
vim.keymap.set({ "n", "v", "o" }, "ö", "[", { remap = true, desc = "German keyboard: map ö → [" })
vim.keymap.set({ "n", "v", "o" }, "ä", "]", { remap = true, desc = "German keyboard: map ä → ]" })

vim.keymap.set({ "n", "v", "o" }, "Ö", "{", { remap = true, desc = "German keyboard: map Ö → {" })
vim.keymap.set({ "n", "v", "o" }, "Ä", "}", { remap = true, desc = "German keyboard: map Ä → }" })
