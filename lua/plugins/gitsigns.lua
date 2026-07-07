return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '-' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    current_line_blame = true,
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', '<leader>hn', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Git [H]unk [N]ext' })

      map('n', '<leader>hp', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Git [H]unk [P]revious' })

      -- Actions
      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Git [H]unk [S]tage' })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Git [H]unk [R]eset' })

      map('v', '<leader>hs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Git [H]unk [S]tage (visual)' })

      map('v', '<leader>hr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Git [H]unk [R]eset (visual)' })

      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Git [H]unk [S]tage buffer' })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Git [H]unk [R]eset buffer' })
      map('n', '<leader>hv', gitsigns.preview_hunk, { desc = 'Git [H]unk [V]iew/preview' })
      map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'Git [H]unk [I]nline preview' })

      map('n', '<leader>hb', function()
        gitsigns.blame_line { full = true }
      end, { desc = 'Git [H]unk [B]lame line' })

      map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Git [H]unk [D]iff this' })

      map('n', '<leader>hD', function()
        gitsigns.diffthis '~'
      end, { desc = 'Git [H]unk [D]iff against last commit' })

      map('n', '<leader>hQ', function()
        gitsigns.setqflist 'all'
      end, { desc = 'Git [H]unk [Q]uickfix list (all)' })
      map('n', '<leader>hq', gitsigns.setqflist, { desc = 'Git [H]unk [Q]uickfix list' })

      -- Toggles
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git [B]lame' })
      map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle [W]ord diff' })

      -- Text object
      map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
    end,
  },
}
