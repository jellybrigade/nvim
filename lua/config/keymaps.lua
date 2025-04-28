vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil" })
vim.keymap.set("n", "gl", function()
    vim.diagnostic.open_float()
end, { desc = "Open Diagnostics in Float" })

vim.keymap.set("n", "<leader>cf", function()
    require("conform").format({
        lsp_format = "fallback",
    })
end, { desc = "Format current file" })

-- Map <leader>fp to open projects
vim.keymap.set("n", "<C-p>", ":ProjectFzf<CR>", { noremap = true, silent = true })
vim.keymap.set(
    "n",
    "<Esc><Esc>",
    "<cmd>noh<CR><Esc>",
    { noremap = true, silent = true, desc = "Clear Search Highlight / Exit" }
)
vim.keymap.set("n", "YY", 'ma gg V G "+y `a', { noremap = true, desc = "Copy Entire Document to Clipboard" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", { noremap = true, desc = "Quit All (Force)" })
vim.keymap.set("n", "<leader>q", "<cmd>wq<CR>", { noremap = true, desc = "Write & Quit" })
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { noremap = true, desc = "Write" })

vim.keymap.set("n", "<M-C-p>", "<cmd>ScratchOpen<cr>")
vim.keymap.set("n", "<M-C-n>", "<cmd>Scratch<cr>")
vim.keymap.set("n", "<leader>gg", function()
    require("neogit").open()
end, { noremap = true, silent = true, desc = "Neogit Status" })
vim.keymap.set("n", "<leader>gc", function()
    require("neogit").open({ "commit" })
end, { noremap = true, silent = true, desc = "Neogit Commit" })
vim.keymap.set("n", "<leader>gS", function()
    require("neogit").open({ kind = "split" })
end, { noremap = true, silent = true, desc = "Neogit Split" })

-- Everything below is stuff I yanked from daddy ThePrimeagen
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join Lines (Keep Cursor Pos)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down (Centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up (Centered)" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next Search Result (Centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous Search Result (Centered)" })
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste Over Selection (Keep Yank)" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to System Clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank Line to System Clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>D", '"_d', { desc = "Delete (Black Hole)" })
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex Mode" })
vim.keymap.set("n", "q:", "<nop>", { desc = "Disable command thing when trying to quit" })
vim.keymap.set(
    "n",
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Search/Replace Word Under Cursor" }
)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make File Executable" })
vim.keymap.set(
    "n",
    "<leader>ee",
    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>",
    { desc = "Go: Insert `if err != nil { return err }`" }
)
vim.keymap.set("n", "<leader>ea", 'oassert.NoError(err, "")<Esc>F";a', { desc = "Go: Insert `assert.NoError(err)`" })
vim.keymap.set(
    "n",
    "<leader>ef",
    'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj',
    { desc = "Go: Insert `if err != nil { log.Fatalf(...) }`" }
)
vim.keymap.set(
    "n",
    "<leader>el",
    'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i',
    { desc = "Go: Insert `if err != nil { logger.Error(...) }`" }
)
vim.keymap.set("n", "<leader>fml", function()
    require("cellular-automaton").start_animation("make_it_rain")
end, { desc = "Cellular Automaton (Rain)" })
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end, { desc = "Source Last Script (Reload Config)" })
