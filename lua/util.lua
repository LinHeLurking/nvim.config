local util = {}

util.is_in_wsl = function()
  return os.getenv("WSL_DISTRO_NAME") ~= nil
end

util.get_config_dir = function()
  -- Thanks https://mitchellt.com/2022/05/15/WSL-Neovim-Lua-and-the-Windows-Clipboard.html
  local in_wsl = util.is_in_wsl()
  if in_wsl then
    return os.getenv("HOME") .. "/.config/nvim"
  else
    return "~/AppData/Local/nvim/"
  end
end

return util
