return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
      },
      formatters = {
        -- AOSP style is google-java-format's 4-space variant; the default is 2.
        ["google-java-format"] = {
          prepend_args = { "--aosp" },
        },
      },
    },
  },
}
