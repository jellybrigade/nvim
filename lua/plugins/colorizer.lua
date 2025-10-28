return {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      filetypes = { "*" },
      user_default_options = {
        RGB = true,          -- RGB hex codes
        RRGGBB = true,       -- RRGGBB hex codes
        names = true,        -- CSS color names
        RRGGBBAA = false,    -- RRGGBBAA hex codes
        AARRGGBB = false,    -- AARRGGBB hex codes
        rgb_fn = false,      -- CSS rgb() functions
        hsl_fn = false,      -- CSS hsl() functions
        css = false,         -- Enable all CSS features
        css_fn = false,      -- Enable CSS functions
        mode = "background", -- Can be "background", "foreground", or "virtualtext"
      },
    })
  end,
}
