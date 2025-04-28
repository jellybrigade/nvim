return {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
    dependencies = {
        { "ibhagwan/fzf-lua" },
    },
    config = function()
        require("scratch").setup({
            -- Directory to store scratch files
            scratch_file_dir = vim.fn.stdpath("cache") .. "/scratch.nvim",
            -- How the scratch window opens ('rightbelow vsplit', 'vsplit', 'split', 'edit', 'tabedit')
            window_cmd = "rightbelow vsplit",
            -- File picker integration (using fzf-lua as recommended)
            use_telescope = true,
            file_picker = "fzflua", -- "fzflua" or "telescope"

            -- Simple list of filetypes for quick scratch buffer creation
            -- Add filetypes here that don't need special templates or extensions
            filetypes = {
                "lua", -- Keep Lua for Neovim config snippets
                "sh", -- Shell scripts
                "js", -- JavaScript
                "ts", -- TypeScript
                "css", -- CSS
                "scss", -- SCSS
                "json", -- JSON
                "yaml", -- YAML
                "toml", -- TOML
                "md", -- Markdown
                "sql", -- SQL
            },

            -- Detailed configuration for specific filetypes
            -- Use this for templates, specific extensions, subdirectories, etc.
            filetype_details = {
                -- HTML scratch file with a basic template
                html = {
                    content = {
                        "<!DOCTYPE html>",
                        '<html lang="en">',
                        "<head>",
                        '  <meta charset="UTF-8">',
                        '  <meta name="viewport" content="width=device-width, initial-scale=1.0">',
                        "  <title>Scratch</title>",
                        "  <style>",
                        "    ", -- Placeholder for CSS
                        "  </style>",
                        "</head>",
                        "<body>",
                        "  <h1>Scratch Pad</h1>",
                        "  <p></p>",
                        "  <script>",
                        "    ", -- Placeholder for JS
                        "  </script>",
                        "</body>",
                        "</html>",
                    },
                    cursor = { location = { 13, 8 }, insert_mode = true }, -- Cursor inside <p> tag
                },
                -- Vue 3 <script setup> scratch file
                vue = {
                    content = {
                        "<template>",
                        "  <div>",
                        "    <h1></h1>",
                        "  </div>",
                        "</template>",
                        "",
                        '<script setup lang="ts">',
                        "import { ref } from 'vue'",
                        "",
                        "const message = ref('Hello Scratch!')",
                        "</script>",
                        "",
                        "<style scoped>",
                        "h1 {",
                        "  color: #42b883;",
                        "}",
                        "</style>",
                    },
                    cursor = { location = { 3, 10 }, insert_mode = true }, -- Cursor inside <h1>
                },
                -- PHP scratch file
                php = {
                    content = { "<?php", "", "declare(strict_types=1);", "", "" },
                    cursor = { location = { 5, 1 }, insert_mode = true }, -- Cursor after declare
                },
                -- Laravel Blade scratch file
                blade = {
                    extension = "blade.php", -- Use the correct extension
                    content = {
                        "@extends('layouts.app')", -- Example boilerplate
                        "",
                        "@section('content')",
                        '  <div class="container">',
                        "    <h1>Scratch Blade</h1>",
                        "    <p></p>",
                        "  </div>",
                        "@endsection",
                        "",
                        "@push('scripts')",
                        "  <script>",
                        "    ",
                        "  </script>",
                        "@endpush",
                    },
                    cursor = { location = { 6, 8 }, insert_mode = true }, -- Cursor inside <p> tag
                },
                -- Rust scratch file
                rs = {
                    content = { "fn main() {", '    println!("Hello, scratch!");', "    ", "}" },
                    cursor = { location = { 3, 5 }, insert_mode = true }, -- Cursor after println
                },
                -- Go scratch file (using existing config as example)
                go = {
                    requireDir = true, -- Each Go scratch file gets its own directory
                    filename = "main", -- The filename within the directory
                    content = {
                        "package main",
                        "",
                        'import "fmt"',
                        "",
                        "func main() {",
                        '  fmt.Println("Hello Scratch!")',
                        "  ",
                        "}",
                    },
                    cursor = { location = { 7, 3 }, insert_mode = true }, -- Cursor after Println
                },
                -- You can add more details here, e.g., for project-specific notes
                -- ["my-project-notes.md"] = {
                --   subdir = "my-project" -- Group scratch files under specific sub folder
                -- },
            },

            -- Optional: Local keymaps specific to scratch buffers
            localKeys = {
                {
                    -- Keymap specific to shell scratch files
                    filenameContains = { ".sh" }, -- Matches files ending in .sh
                    LocalKeys = {
                        {
                            cmd = "<CMD>RunShellCurrentLine<CR>", -- Assumes you have a command like this
                            key = "<C-r>", -- Control+R
                            modes = { "n", "i", "v" }, -- Normal, Insert, Visual modes
                            description = "Run current line in shell",
                        },
                    },
                },
                -- Add more local keymaps if needed
            },

            -- Optional: Hooks to run when creating scratch files
            hooks = {
                -- Example hook (currently adds "hello world")
                -- {
                --   callback = function()
                --     vim.api.nvim_buf_set_lines(0, 0, -1, false, { "hello", "world" })
                --   end,
                -- },
            },
        })
    end,
}
