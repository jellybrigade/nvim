return {
    "ahmedkhalf/project.nvim",
    init = function()
        require("project_nvim").setup({
            show_hidden = true,
            patterns = {
                ".git",
                "_darcs",
                ".hg",
                ".bzr",
                ".svn",
                "package.json",
                "tsconfig.json",
                "Makefile",
                "CMakeLists.txt",
                "meson.build",
                "pyproject.toml",
                "setup.py",
                "Pipfile",
                "requirements.txt",
                "manage.py",
                "pom.xml",
                "build.gradle",
                "build.gradle.kts",
                "Gemfile",
                "config.ru",
                "Cargo.toml",
                "go.mod",
                "composer.json",
                "artisan",
                "mix.exs",
                "stack.yaml",
                "*.cabal",
                "build.sbt",
                "*.sln",
                "*.csproj",
                "*.vbproj",
                "*.fsproj",
                "Package.swift",
                "vite.config.js",
                "vite.config.ts",
                "webpack.config.js",
                "gulpfile.js",
                "Gruntfile.js",
                "rollup.config.js",
                "angular.json",
                "vue.config.js",
                "nuxt.config.js",
                "nuxt.config.ts",
                "next.config.js",
                "remix.config.js",
                "gatsby-config.js",
                "svelte.config.js",
                "nest-cli.json",
                "tailwind.config.js",
                "tailwind.config.ts",
                "postcss.config.js",
                ".eslintrc.js",
                ".eslintrc.json",
                ".eslintrc.yaml",
                ".eslintrc.yml",
                ".eslintignore",
                ".prettierrc.js",
                ".prettierrc.json",
                ".prettierrc.yaml",
                ".prettierrc.yml",
                "prettier.config.js",
                ".prettierignore",
                ".stylelintrc.json",
                ".stylelintrc.js",
                ".stylelintrc.yaml",
                ".stylelintrc.yml",
                "babel.config.js",
                "babel.config.json",
                ".babelrc",
                "vercel.json",
                "netlify.toml",
                "firebase.json",
                "wrangler.toml",
                "serverless.yml",
                "serverless.ts",
                "docker-compose.yml",
                "docker-compose.yaml",
                "Dockerfile",
                "Vagrantfile",
                ".editorconfig",
                ".env",
            },
            -- your configuration comes her
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        })

        -- Absolutely minimal implementation of fzf-lua based project finder
        -- for fzf-lua, due to request from @KrisWilliams1 (Maybe extended to a
        -- full blown port from the original selector in the future)
        local history = require("project_nvim.utils.history")
        local project = require("project_nvim.project")

        vim.api.nvim_create_user_command("FzfProjects", function()
            local projects = history.get_recent_projects()

            require("fzf-lua").fzf_exec(projects, {
                prompt = "Projects> ",
                actions = {
                    ["default"] = function(selected)
                        if selected and #selected > 0 then
                            local project_path = selected[1]
                            if project.set_pwd(project_path, "fzf-lua") then
                                require("fzf-lua").files()
                            end
                        end
                    end,
                },
            })
        end, {})
    end,
    keys = {
        {
            "<C-p>",
            "<cmd>FzfProjects<CR>",
            desc = "Find Recent Projects",
        },
    },
}
