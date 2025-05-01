return {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        { "kevinhwang91/promise-async" },
    },
    opts = function()
        -- Using ufo provider, remap `zR` and `zM`
        vim.keymap.set("n", "zo", require("ufo").openAllFolds)
        vim.keymap.set("n", "zc", require("ufo").closeAllFolds)

        -- Option 2: nvim LSP as LSP client
        -- Add foldingRange capability to LSP client
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        -- List LSP servers manually
        local servers = { "gopls", "clangd" }
        for _, server in ipairs(servers) do
            require("lspconfig")[server].setup({
                capabilities = capabilities,
                -- Additional LSP server setup can go here
            })
        end
    end,
}
