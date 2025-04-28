return {
    "jellydn/quick-code-runner.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
        debug = true,
    },
    cmd = { "QuickCodeRunner", "QuickCodePad" },
    keys = {
        {
            "<leader>cr",
            ":QuickCodeRunner<CR>",
            desc = "Quick Code Runner",
            mode = "v",
        },
        {
            "<leader>cp",
            ":QuickCodePad<CR>",
            desc = "Quick Code Pad",
        },
    },
    file_types = {
        -- Runnable languages
        javascript = { "node" }, -- Or 'bun run', 'deno run'
        typescript = { "ts-node" }, -- Or 'bun run', 'deno run'. Requires: npm i -g ts-node typescript
        python = { "python3 -u" }, -- Keep default, or use 'python -u' if python3 isn't your command
        go = { "go run" }, -- Keep default
        lua = { "lua" }, -- Keep default
        c = { "tcc -run" }, -- Requires Tiny C Compiler (tcc). Simpler for single files.
        -- Alternative for GCC/Clang (compiles to /tmp/qcr_out, then runs):
        -- 'sh -c "cc $1 -o /tmp/qcr_out && /tmp/qcr_out"'
        rust = { "cargo-script" }, -- Requires: cargo install cargo-script. Handles single files/scripts well.
        -- Alternative: 'rustc $1 -o /tmp/qcr_rust_out && /tmp/qcr_rust_out' might work for simple cases

        -- Data/Config formats (using linters/formatters/processors)
        json = { "jq ." }, -- Requires jq. Pretty-prints/validates JSON.
        yaml = { "yamllint -", "yq ." }, -- Requires yamllint or yq. yamllint checks syntax, yq processes/formats. Tries yamllint first.
        toml = { "taplo format -", "toml-lint" }, -- Requires taplo CLI or toml-lint. taplo formats, toml-lint checks. Tries taplo first.
    },
}
