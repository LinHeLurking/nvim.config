local util = require("util")

local in_wsl = util.is_in_wsl()
local in_windows = util.is_in_windows()

local function osc_copy(lines, _)
  require("osc52").copy(table.concat(lines, "\n"))
end


if in_wsl then
  local home = os.getenv("HOME")
  local wsl_paste = { home .. "/.config/nvim/sh/nvim_paste.sh" }

  vim.g.clipboard = {
    name = "wsl-clip",
    copy = { ["+"] = osc_copy,["*"] = osc_copy },
    paste = { ["+"] = wsl_paste,["*"] = wsl_paste },
  }
elseif in_windows then
  local pwsh_paste = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'
  vim.g.clipboard = {
    name = "win-clip",
    copy = { ["+"] = { "clip.exe" },["*"] = { "clip.exe" } },
    paste = { ["+"] = pwsh_paste,["*"] = pwsh_paste },
  }
end
