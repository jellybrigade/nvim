-- oil.nvim — edit the filesystem like a normal buffer.
--
-- `-` opens the parent directory of the current file in a floating window.
-- Config follows the teamlead's kickstart setup (hidden files, natural order,
-- LSP-aware renames), with the float sizing/border from the from-scratch config.
--
-- everforest runs with `transparent_background = 2`, so `Normal` carries no
-- background. Oil's floats default to `NormalFloat`, which does have one, and a
-- solid slab over a transparent editor looks out of place. `winhighlight` below
-- points every float back at `Normal` so the terminal shows through, with the
-- border picking up `Comment` (grey, no background) instead of `FloatBorder`.
local float_win_options = {
  winhighlight = table.concat({
    "Normal:Normal",
    "NormalFloat:Normal",
    "FloatBorder:Comment",
    "FloatTitle:Title",
  }, ","),
}

return {
  "stevearc/oil.nvim",
  -- LazyVim already ships mini.icons; name it under the current org so lazy.nvim
  -- does not flag the old `echasnovski/*` path as a rename.
  dependencies = { "nvim-mini/mini.icons" },
  -- Oil hijacks netrw, so lazy-loading it is explicitly not recommended.
  lazy = false,
  keys = {
    { "-", "<cmd>Oil --float<cr>", desc = "Open parent directory (oil)" },
  },
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      natural_order = true,
      is_always_hidden = function(name, _)
        return name == ".." or name == ".git" or name == ".idea"
      end,
    },
    win_options = {
      wrap = true,
    },
    float = {
      border = "rounded",
      max_width = 100,
      max_height = 30,
      win_options = float_win_options,
    },
    -- Keep the secondary popups on the same treatment, so a rename confirmation
    -- does not appear as a grey slab next to a transparent browse window.
    confirmation = { border = "rounded", win_options = float_win_options },
    progress = { border = "rounded", win_options = float_win_options },
    keymaps_help = { border = "rounded" },
    lsp_file_methods = {
      enabled = true,
      timeout_ms = 700,
      -- Save buffers that LSP rewrote during a willRenameFiles.
      autosave_changes = true,
    },
    keymaps = {
      -- Deliberately no <Esc> close: a reflex second <Esc> after renaming in
      -- insert mode would throw away the pending file operations.
      ["q"] = { "actions.close", mode = "n" },
      -- Writing the oil buffer is what applies the pending file operations.
      ["<leader><CR>"] = {
        callback = function()
          vim.cmd("write")
        end,
        desc = "Apply pending oil changes (:write)",
        mode = "n",
      },
    },
  },
}
