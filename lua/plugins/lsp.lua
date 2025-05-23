return {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        -- Mason must be loaded before its dependents so we need to set it up here.
        -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
        { "williamboman/mason.nvim", opts = {} },
        "posva/vim-vue",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",

        -- Useful status updates for LSP.
        { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
        -- Brief aside: **What is LSP?**
        --
        -- LSP is an initialism you've probably heard, but might not understand what it is.
        --
        -- LSP stands for Language Server Protocol. It's a protocol that helps editors
        -- and language tooling communicate in a standardized fashion.
        --
        -- In general, you have a "server" which is some tool built to understand a particular
        -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
        -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
        -- processes that communicate with some "client" - in this case, Neovim!
        --
        -- LSP provides Neovim with features like:
        --  - Go to definition
        --  - Find references
        --  - Autocompletion
        --  - Symbol Search
        --  - and more!
        --
        -- Thus, Language Servers are external tools that must be installed separately from
        -- Neovim. This is where `mason` and related plugins come into play.
        --
        -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
        -- and elegantly composed help section, `:help lsp-vs-treesitter`

        --  This function gets run when an LSP attaches to a particular buffer.
        --    That is to say, every time a new file is opened that is associated with
        --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
        --    function will be executed to configure the current buffer
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                -- NOTE: Remember that Lua is a real programming language, and as such it is possible
                -- to define small helper and utility functions so you don't have to repeat yourself.
                --
                -- In this case, we create a function that lets us more easily define mappings specific
                -- for LSP related items. It sets the mode, buffer and description for us each time.
                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                -- Jump to the definition of the word under your cursor.
                --  This is where a variable was first declared, or where a function is defined, etc.
                --  To jump back, press <C-t>.
                map("gd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")

                -- Find references for the word under your cursor.
                map("gr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")

                -- Jump to the implementation of the word under your cursor.
                --  Useful when your language has ways of declaring types without an actual implementation.
                map("gI", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementation")

                -- Jump to the type of the word under your cursor.
                --  Useful when you're not sure what type a variable is and you want to see
                --  the definition of its *type*, not where it was *defined*.
                map("<leader>D", require("fzf-lua").lsp_typedefs, "Type [D]efinition")

                -- Fuzzy find all the symbols in your current document.
                --  Symbols are things like variables, functions, types, etc.
                map("<leader>ds", require("fzf-lua").lsp_document_symbols, "[D]ocument [S]ymbols")

                -- Fuzzy find all the symbols in your current workspace.
                --  Similar to document symbols, except searches over your entire project.
                map("<leader>ws", require("fzf-lua").lsp_live_workspace_symbols, "[W]orkspace [S]ymbols")

                -- Rename the variable under your cursor.
                --  Most Language Servers support renaming across files, etc.
                map("<leader>cr", vim.lsp.buf.rename, "[R]e[n]ame")

                -- Execute a code action, usually your cursor needs to be on top of an error
                -- or a suggestion from your LSP for this to activate.
                map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

                -- WARN: This is not Goto Definition, this is Goto Declaration.
                --  For example, in C this would take you to the header.
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
                ---@param client vim.lsp.Client
                ---@param method vim.lsp.protocol.Method
                ---@param bufnr? integer some lsp support methods only in specific files
                ---@return boolean
                local function client_supports_method(client, method, bufnr)
                    if vim.fn.has("nvim-0.11") == 1 then
                        return client:supports_method(method, bufnr)
                    else
                        return client.supports_method(method, { bufnr = bufnr })
                    end
                end

                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if
                    client
                    and client_supports_method(
                        client,
                        vim.lsp.protocol.Methods.textDocument_documentHighlight,
                        event.buf
                    )
                then
                    local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                        end,
                    })
                end

                -- The following code creates a keymap to toggle inlay hints in your
                -- code, if the language server you are using supports them
                --
                -- This may be unwanted, since they displace some of your code
                -- if
                --     client
                --     and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
                -- then
                --     map("<leader>th", function()
                --         vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                --     end, "[T]oggle Inlay [H]ints")
                -- end
                -- Enable inlay hints by default and set up a toggle keymap
                -- Check if the client exists and supports the inlay hint method for the current buffer
                if
                    client
                    and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
                then
                    -- Try to enable inlay hints automatically for this buffer when LSP attaches
                    -- The second argument specifies options, including the buffer number.
                    vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })

                    -- Keep the keymap to allow toggling inlay hints off (or back on)
                    -- The description is slightly updated to reflect the new default state.
                    map("<leader>th", function()
                        -- Toggle the current state for the specific buffer
                        vim.lsp.inlay_hint.enable(
                            not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }),
                            { bufnr = event.buf }
                        )
                    end, "[T]oggle Inlay [H]ints (Default: On)")
                end
            end,
        })

        -- Diagnostic Config
        -- See :help vim.diagnostic.Opts
        vim.diagnostic.config({
            severity_sort = true,
            float = { border = "rounded", source = "if_many" },
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚 ",
                    [vim.diagnostic.severity.WARN] = "󰀪 ",
                    [vim.diagnostic.severity.INFO] = "󰋽 ",
                    [vim.diagnostic.severity.HINT] = "󰌶 ",
                },
            },
            virtual_text = {
                source = "if_many",
                spacing = 2,
                format = function(diagnostic)
                    local diagnostic_message = {
                        [vim.diagnostic.severity.ERROR] = diagnostic.message,
                        [vim.diagnostic.severity.WARN] = diagnostic.message,
                        [vim.diagnostic.severity.INFO] = diagnostic.message,
                        [vim.diagnostic.severity.HINT] = diagnostic.message,
                    }
                    return diagnostic_message[diagnostic.severity]
                end,
            },
        })

        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
        local original_capabilities = vim.lsp.protocol.make_client_capabilities()
        local capabilities = require("blink.cmp").get_lsp_capabilities(original_capabilities)
        -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        -- Enable the following language servers
        --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
        --
        --  Add any additional override configuration in the following tables. Available keys are:
        --  - cmd (table): Override the default command used to start the server
        --  - filetypes (table): Override the default list of associated filetypes for the server
        --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  - settings (table): Override the default settings passed when initializing the server.
        --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
        local servers = {
            html = {}, -- Standard HTML LSP
            cssls = {}, -- Standard CSS/SCSS/Less LSP
            jsonls = {}, -- Standard JSON LSP
            emmet_language_server = {},
            ts_ls = { -- Primary JS/TS LSP
                -- settings = { -- Example settings (uncomment/adjust as needed)
                --   typescript = {
                --     inlayHints = {
                --       includeInlayParameterNameHints = 'all',
                --       includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                --       includeInlayFunctionParameterTypeHints = true,
                --       includeInlayVariableTypeHints = true,
                --       includeInlayPropertyDeclarationTypeHints = true,
                --       includeInlayFunctionLikeReturnTypeHints = true,
                --       includeInlayEnumMemberValueHints = true,
                --     },
                --   },
                --   javascript = {
                --     inlayHints = {
                --       includeInlayParameterNameHints = 'all',
                --       includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                --       includeInlayFunctionParameterTypeHints = true,
                --       includeInlayVariableTypeHints = true,
                --       includeInlayPropertyDeclarationTypeHints = true,
                --       includeInlayFunctionLikeReturnTypeHints = true,
                --       includeInlayEnumMemberValueHints = true,
                --     },
                --   },
                -- },
            },
            tailwindcss = { -- Tailwind CSS LSP (intellisense, linting)
                -- Often detects configuration automatically, but you might need to specify filetypes
                -- if it doesn't pick up Vue/Blade correctly.
                filetypes = {
                    "css",
                    "html",
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact",
                    "vue",
                    "blade",
                    "php",
                },
            },

            -- Frameworks
            volar = { -- Recommended LSP for Vue 3 (handles template and script blocks)
                filetypes = { "vue", "javascript", "typescript" }, -- Ensure it handles TS/JS within Vue files
            },
            -- php / Laravel
            intelephense = { -- Powerful PHP LSP (some features may require a license)
                -- settings = { -- Example settings
                --   intelephense = {
                --     stubs = { -- Common PHP stubs
                --       'bcmath', 'core', 'ctype', 'date', 'dom', 'fileinfo', 'filter', 'gd',
                --       'hash', 'iconv', 'intl', 'json', 'libxml', 'mbstring', 'mysqlnd',
                --       'openssl', 'pcntl', 'pcre', 'pdo', 'phar', 'posix', 'readline',
                --       'redis', 'session', 'simplexml', 'sockets', 'sodium', 'sqlite3',
                --       'standard', 'tokenizer', 'xml', 'xmlreader', 'xmlwriter', 'zip', 'zlib',
                --     },
                --     -- environment = { -- Point to PHP executable if needed
                --     --   phpVersion = '8.2', -- Specify your PHP version
                --     -- },
                --   }
                -- }
            },

            -- Backend / Systems
            rust_analyzer = {
                -- settings = { -- Example: enable proc macro support and specific inlay hints
                --   ['rust-analyzer'] = {
                --     procMacro = { enable = true },
                --     checkOnSave = { command = "clippy" },
                --     inlayHints = {
                --       bindingModeHints = { enable = true },
                --       chainingHints = { enable = true },
                --       closingBraceHints = { enable = true, minLines = 5 },
                --       closureCaptureHints = { enable = true },
                --       lifetimeElisionHints = { enable = true, useParameterNames = true },
                --       maxLength = 25,
                --       parameterHints = { enable = true },
                --       rangeExclusiveHints = { enable = true },
                --       reborrowHints = { enable = true },
                --       typeHints = { enable = true, hideLeastRelevant = true },
                --     },
                --   },
                -- },
            },
            gopls = { -- Official Go LSP
                -- settings = {
                --   gopls = {
                --     -- ui.semanticTokens = true, -- Enable semantic tokens if your theme supports it
                --     -- analyses = {
                --     --   unusedparams = true,
                --     -- },
                --     -- staticcheck = true,
                --   },
                -- },
            },
            clangd = { -- C/C++ LSP
                -- cmd = { -- Example: specify path or compile commands db
                --   "clangd",
                --   "--compile-commands-dir=build", -- Adjust if needed
                -- },
            },

            -- Config / Scripting / Markup
            bashls = {}, -- Bash script LSP
            yamlls = { -- YAML LSP
                -- settings = { -- Example: configure with schemas from schema store
                --   yaml = {
                --     schemaStore = {
                --       enable = true,
                --       url = "https://www.schemastore.org/api/json/catalog.json",
                --     },
                --     schemas = require('schemastore').yaml.schemas(), -- Requires schemastore.nvim plugin
                --   },
                -- }
                -- Note: For schema support, consider installing 'b0o/schemastore.nvim'
            },
            taplo = {}, -- TOML LSP & Toolkit
            marksman = {}, -- Markdown LSP (already in your config)

            -- Lua (keep the existing entry for configuring Neovim itself)
            lua_ls = {
                settings = {
                    Lua = {
                        workspace = { checkThirdParty = false }, -- Prevents issues with Neovim runtime files
                        completion = { callSnippet = "Replace" },
                        diagnostics = { globals = { "vim" } }, -- Make LuaLS aware of the 'vim' global
                        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                        -- diagnostics = { disable = { 'missing-fields' } },
                    },
                },
            },
        } -- Ensure the servers and tools above are installed
        --
        -- To check the current status of installed tools and/or manually install
        -- other tools, you can run
        --    :Mason
        --
        -- You can press `g?` for help in this menu.
        --
        -- `mason` had to be setup earlier: to configure its options see the
        -- `dependencies` table for `nvim-lspconfig` above.
        --
        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            "html",
            "cssls",
            "jsonls",
            "emmet_language_server",
            "ts_ls",
            "tailwindcss",
            "volar",
            "intelephense", -- Or "phpactor" if you prefer
            "rust_analyzer",
            "gopls",
            "clangd",
            "bashls",
            "yamlls",
            "taplo",
            "marksman",
            "lua_ls",

            -- Formatters
            "stylua", -- Lua (already present)
            "prettierd", -- JS, TS, JSON, CSS, HTML, YAML, MD (already present)
            "rustfmt", -- Rust (usually installed with rustup, but Mason can manage)
            "goimports", -- Go (formats + manages imports)
            "pint", -- PHP/Laravel (requires PHP >= 8.0)
            "clang-format", -- C/C++
            "shfmt", -- Shell script formatter

            -- Linters
            "eslint_d", -- Faster eslint daemon for JS/TS (recommended over standard eslint)
            "golangci-lint", -- Go linter aggregator
            "shellcheck", -- Shell script linter
            -- Add other linters like 'stylelint' for CSS if desired
        })
        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        require("mason-lspconfig").setup({
            ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
            automatic_installation = true,
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    -- This handles overriding only values explicitly passed
                    -- by the server configuration above. Useful when disabling
                    -- certain features of an LSP (for example, turning off formatting for ts_ls)
                    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                    require("lspconfig")[server_name].setup(server)
                end,
            },
        })
    end,
}
