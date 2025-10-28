return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "j-hui/fidget.nvim",    opts = {} },
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    { "nvimdev/lspsaga.nvim", opts = {} },
    {
      "RRethy/vim-illuminate",
      config = function()
        require('illuminate').configure({})
      end
    },
  },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Configure vtsls (Vue TypeScript Server) - REQUIRED for vue_ls v3+
    vim.lsp.config("vtsls", {
      capabilities = capabilities,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
          }
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
          }
        }
      }
    })

    -- Configure other LSPs
    vim.lsp.config("eslint", { capabilities = capabilities })
    vim.lsp.config("html", { capabilities = capabilities })
    vim.lsp.config("cssls", { capabilities = capabilities })
    vim.lsp.config("jsonls", { capabilities = capabilities })
    vim.lsp.config("tailwindcss", { capabilities = capabilities })
    vim.lsp.config("graphql", { capabilities = capabilities })
    vim.lsp.config("yamlls", { capabilities = capabilities })

    -- Enable all LSPs EXCEPT vue_ls (which needs special handling)
    vim.lsp.enable(
      "vtsls", -- Must be enabled FIRST
      "eslint",
      "html",
      "cssls",
      "jsonls",
      "tailwindcss",
      "graphql",
      "yamlls"
    )

    -- Special handling for vue_ls - must wait for vtsls to be ready 【2】
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- Only initialize vue_ls when vtsls is attached
        if client.name == "vtsls" then
          vim.schedule(function()
            -- Configure vue_ls to use vtsls as its TypeScript plugin 【1】
            vim.lsp.config("vue_ls", {
              capabilities = capabilities,
              settings = {
                vetur = {
                  validation = {
                    template = true,
                    style = true,
                    script = true
                  }
                },
                typescript = {
                  serverPath = vim.fn.stdpath('data') ..
                  '/mason/packages/volar/server/node_modules/typescript/lib/tsserverlibrary.js'
                }
              },
              on_init = function(client)
                -- Fix for semantic tokens in vue_ls v3.0.2+ 【4】
                client.server_capabilities.semanticTokensProvider = {
                  full = true
                }
              end
            })

            -- Start vue_ls for the current buffer
            vim.lsp.start("vue_ls", {
              bufnr = args.buf,
              capabilities = capabilities
            })
          end)
        end
      end
    })

    -- LSP keybindings (unchanged from your original)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }

        -- Enhanced LSP keybindings with lspsaga
        vim.keymap.set(
          "n",
          "K",
          "<cmd>Lspsaga hover_doc<cr>",
          vim.tbl_extend("force", opts, { desc = "Hover information (Lspsaga)" })
        )
        -- [Rest of your keybindings remain unchanged]
      end,
    })
  end,
}
