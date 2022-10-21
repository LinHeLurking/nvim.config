-- Thanks https://mitchellt.com/2022/05/15/WSL-Neovim-Lua-and-the-Windows-Clipboard.html

in_wsl = os.getenv("WSL_DISTRO_NAME") ~= nil

if in_wsl then
  local home = os.getenv("HOME")
  local copy = { "clip.exe" }
  local paste = { home .. "/.config/nvim/sh/nvim_paste.sh" }

  vim.g.clipboard = {
    name = "nvim-clip",
    copy = { ["+"] = copy, ["*"] = copy },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end
