-- Java: 4-space indent (google-java-format runs with --aosp to match).
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true

-- Fold with treesitter (block comments included via after/queries/java/folds.scm).
-- Set locally so LazyVim doesn't swap in jdtls's foldexpr when it attaches.
vim.wo[0][0].foldmethod = "expr"
vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Collapse Javadoc the first time the buffer is shown in a window.
local javadoc = vim.treesitter.query.parse("java", [[((block_comment) @doc (#lua-match? @doc "^/%*%*"))]])

local function fold_javadoc(buf)
  local parser = vim.treesitter.get_parser(buf, "java", { error = false })
  if not parser then
    return
  end
  local starts = {}
  for _, node in javadoc:iter_captures(parser:parse()[1]:root(), buf) do
    local srow, _, erow = node:range()
    if erow > srow then
      table.insert(starts, srow + 1)
    end
  end
  for i = #starts, 1, -1 do
    local lnum = starts[i]
    if vim.fn.foldclosed(lnum) == -1 then
      vim.cmd(lnum .. "foldclose")
      -- No fold starts here: :foldclose hit the enclosing one, undo it.
      if vim.fn.foldclosed(lnum) ~= lnum then
        vim.cmd(lnum .. "foldopen")
      end
    end
  end
end

-- At startup the file is already in its window before this ftplugin runs.
local buf = vim.api.nvim_get_current_buf()
if vim.fn.bufwinid(buf) ~= -1 then
  vim.schedule(function()
    if vim.api.nvim_get_current_buf() == buf then
      fold_javadoc(buf)
    end
  end)
else
  vim.api.nvim_create_autocmd("BufWinEnter", {
    buffer = buf,
    once = true,
    callback = function(args)
      fold_javadoc(args.buf)
    end,
  })
end
