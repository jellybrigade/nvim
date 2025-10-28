vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.opt.termguicolors = true


-- Leader key must be set before lazy.nvim is loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set up plugins from the lua/plugins directory
require("lazy").setup("plugins")

-- Import core configuration modules
require("core.options")
require("core.keymaps")
