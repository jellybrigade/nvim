-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- .qnote quick-capture filetype (inbox notes -> vault subfolder as .md)
require("config.qnote")

vim.opt.scrolloff = 8

-- GNOME has no wlr-data-control, so wl-paste has to steal focus to read the
-- clipboard and hangs nvim after switching apps. Use xclip via Xwayland instead.
vim.g.clipboard = "xclip"
