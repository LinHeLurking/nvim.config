local util = {}

util.is_in_wsl = function()
  return os.getenv("WSL_DISTRO_NAME") ~= nil
end

util.is_in_windows = function()
  local name = vim.loop.os_uname().sysname
  return name:find("Win") and true or false
end

util.get_config_dir = function()
  if util.is_in_windows() then
    -- Windows
    return os.getenv("LOCALAPPDATA") .. "/nvim/"
  else
    -- Linux
    return os.getenv("HOME") .. "/.config/nvim"
  end
end

util.async_format = function()
  vim.lsp.buf.format({
    async = true,
    filter = function(client)
      -- Disable format ability for Volar, TsServer
      local name = client.name
      return name ~= "volar" and name ~= "tsserver"
    end,
  })
end

return util
