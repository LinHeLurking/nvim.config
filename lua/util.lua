local util = {}

local name = vim.loop.os_uname().sysname

util.is_in_windows = function()
  return name:find("Win") and true or false
end

util.is_in_linux = function()
  return name == "Linux"
end

util.is_in_macos = function()
  return name == "Darwin"
end

util.is_in_wsl = function()
  return util.is_in_linux() and os.getenv("WSL_DISTRO_NAME") ~= nil
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

util.buffer_del_switch_focus = function(bufnr)
  local cur_bufnr = vim.api.nvim_get_current_buf()
  vim.cmd("bdelete! " .. tostring(bufnr))
  if cur_bufnr == bufnr then
    for _, buf in pairs(vim.fn.getbufinfo()) do
      if buf.name ~= "" and buf.loaded == 1 and buf.listed == 1 and buf.linecount > 1 then
        -- print("Switch focus to buffer: " .. buf.bufnr)
        vim.api.nvim_set_current_buf(buf.bufnr)
        break
      end
    end
  end
  require("bufferline.ui").refresh()
end

return util
