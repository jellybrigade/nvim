-- LazyVim's java extra roots jdtls at the nearest gradle/maven/git marker. A
-- standalone .java file sitting next to such a project (but outside its source
-- sets) is then unknown to the build, so jdtls answers every request with
-- nothing -- hover reports "No information available". Root those files at
-- their own directory so jdtls treats them as single-file sources.
--
-- An existing jdtls workspace also never picks up subprojects added to
-- settings.gradle later (e.g. by s.sh / script.sh), and :JdtUpdateConfig only
-- refreshes projects it already knows. So run java.project.import whenever
-- settings.gradle is newer than the last import, and watch it while running.
local stamp_dir = vim.fn.stdpath("state") .. "/jdtls-import"
local watchers = {}

local function settings_file(root)
  for _, name in ipairs({ "settings.gradle", "settings.gradle.kts" }) do
    local path = root .. "/" .. name
    local stat = vim.uv.fs_stat(path)
    if stat then
      return path, stat.mtime.sec
    end
  end
end

local function stamp_path(root)
  return stamp_dir .. "/" .. vim.fn.sha256(root):sub(1, 16)
end

local function last_import(root)
  local ok, lines = pcall(vim.fn.readfile, stamp_path(root))
  return ok and tonumber(lines[1]) or 0
end

local function import_projects(client, root, mtime)
  client:request("workspace/executeCommand", { command = "java.project.import", arguments = {} }, function(err)
    if err then
      vim.notify("jdtls: import failed: " .. err.message, vim.log.levels.WARN)
      return
    end
    vim.fn.mkdir(stamp_dir, "p")
    vim.fn.writefile({ tostring(mtime) }, stamp_path(root))
    vim.notify("jdtls: new Gradle projects imported")
  end)
end

local function check(client, root)
  local _, mtime = settings_file(root)
  if mtime and mtime > last_import(root) then
    import_projects(client, root, mtime)
  end
end

local function watch(client, root)
  if watchers[client.id] then
    return
  end
  local event = vim.uv.new_fs_event()
  local timer = vim.uv.new_timer()
  event:start(root, {}, function(_, filename)
    if filename ~= "settings.gradle" and filename ~= "settings.gradle.kts" then
      return
    end
    timer:start(1000, 0, vim.schedule_wrap(function()
      if client:is_stopped() then
        event:close()
        timer:close()
        watchers[client.id] = nil
      else
        check(client, root)
      end
    end))
  end)
  watchers[client.id] = true
end

return {
  {
    "mfussenegger/nvim-jdtls",
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local root = client and client.name == "jdtls" and client.config.root_dir
          if root and settings_file(root) then
            check(client, root)
            watch(client, root)
          end
        end,
      })
    end,
    opts = function(_, opts)
      opts.root_dir = function(path)
        local root = vim.fs.root(path, vim.lsp.config.jdtls.root_markers)
        if root and path:find("/src/", 1, true) then
          return root
        end
        return vim.fs.dirname(path)
      end
    end,
  },
}
