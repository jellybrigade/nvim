-- .qnote: quick-capture filetype for the Obsidian inbox.
-- Opened by ~/scripts/notes/inbox-capture.sh in a floating nvim. Buffer-local
-- shortcuts let you file the note into a vault subfolder as .md and quit.
--
-- Required from options.lua (loaded before startup) so the filetype and its
-- FileType autocmd exist before the capture buffer is created at launch.

local VAULT = vim.fn.expand("~/Documents/Obsidian/Work Vault/Work")

-- Map the extension to its own filetype so nothing else picks it up.
vim.filetype.add({ extension = { qnote = "qnote" } })

-- Vault folders (top level + one level of subfolders, e.g. "Random/Important"),
-- excluding dotfolders (.obsidian/.trash) and the inbox itself.
local function target_folders()
  local dirs = {}
  for _, name in ipairs(vim.fn.readdir(VAULT) or {}) do
    local p = VAULT .. "/" .. name
    if vim.fn.isdirectory(p) == 1 and name:sub(1, 1) ~= "." and name ~= "Inbox" then
      table.insert(dirs, name)
      for _, sub in ipairs(vim.fn.readdir(p) or {}) do
        if vim.fn.isdirectory(p .. "/" .. sub) == 1 and sub:sub(1, 1) ~= "." then
          table.insert(dirs, name .. "/" .. sub)
        end
      end
    end
  end
  table.sort(dirs)
  return dirs
end

-- Write the buffer to <folder>/<name>.md, drop the temp .qnote, and quit.
local function write_note(folder, name)
  if not name or name:match("^%s*$") then
    return
  end
  name = vim.trim(name):gsub("%.md$", "")
  local dir = VAULT .. "/" .. folder
  vim.fn.mkdir(dir, "p")
  local target = string.format("%s/%s.md", dir, name)
  if vim.fn.filereadable(target) == 1 then
    vim.notify("Exists, not overwriting: " .. target, vim.log.levels.ERROR)
    return
  end
  vim.cmd("write " .. vim.fn.fnameescape(target))
  local tmp = vim.api.nvim_buf_get_name(0)
  if tmp:match("%.qnote$") and vim.fn.filereadable(tmp) == 1 then
    vim.fn.delete(tmp)
  end
  vim.cmd("qa!")
end

-- Preset filename generators.
local function gen_name(kind)
  if kind == "date" then
    return os.date("%Y-%m-%d")
  elseif kind == "datetime" then
    return os.date("%Y-%m-%dT%H%M%S")
  elseif kind == "uuid" then
    local u = vim.trim(vim.fn.system("uuidgen"))
    if u == "" or vim.v.shell_error ~= 0 then
      u = os.date("%Y%m%dT%H%M%S")
    end
    return u
  end
end

-- Type a literal name, or +d (date) / +t (date+time) / +u (uuid) to auto-generate.
local function pick_name(folder)
  local name = vim.trim(vim.fn.input("Filename (+d date / +t date+time / +u uuid, inline ok): "))
  if name == "" then
    return
  end
  -- Expand +d / +t / +u tokens anywhere in the name (e.g. "hello +d").
  name = name:gsub("%+([dtu])%a*", function(c)
    return gen_name(({ d = "date", t = "datetime", u = "uuid" })[c])
  end)
  write_note(folder, name)
end

local function save_note()
  vim.ui.select(target_folders(), { prompt = "Save note to folder:" }, function(folder)
    if not folder then
      return
    end
    pick_name(folder)
  end)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qnote",
  callback = function(ev)
    local buf = ev.buf
    -- Markdown editing feel + highlighting without changing the filetype.
    vim.bo[buf].commentstring = "<!-- %s -->"
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.opt_local.spell = true
    pcall(vim.treesitter.start, buf, "markdown")

    local opts = { buffer = buf, silent = true }
    vim.keymap.set({ "n", "i" }, "<C-s>", function()
      vim.cmd("stopinsert")
      save_note()
    end, vim.tbl_extend("force", opts, { desc = "Save capture to vault" }))
    vim.keymap.set({ "n", "i" }, "<C-q>", function()
      local tmp = vim.api.nvim_buf_get_name(buf)
      if tmp:match("%.qnote$") and vim.fn.filereadable(tmp) == 1 then
        vim.fn.delete(tmp)
      end
      vim.cmd("qa!")
    end, vim.tbl_extend("force", opts, { desc = "Discard capture" }))
  end,
})
