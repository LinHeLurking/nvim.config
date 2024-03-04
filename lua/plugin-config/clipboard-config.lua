local M = {}
M.setup = function()
  local util = require("util")

  local in_wsl = util.is_in_wsl()
  local in_windows = util.is_in_windows()
  local in_vscode = vim.g.vscode ~= nil
  local in_macos = util.is_in_macos()
  local in_linux = util.is_in_linux()

  local function osc_copy(lines, _)
    require("osc52").copy(table.concat(lines, "\n"))
  end

  local pwsh_paste = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'
  local simple_paste = function()
    return {
      vim.fn.split(vim.fn.getreg(""), "\n"),
      vim.fn.getregtype(""),
    }
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
    if in_vscode then
      -- vim.g.clipboard = {
      --   name = "vsc-clip",
      --   copy = { ["+"] = osc_copy,["*"] = osc_copy },
      --   paste = { ["+"] = simple_paste,["*"] = simple_paste },
      -- }
    else
      vim.g.clipboard = {
        name = "win-clip",
        copy = { ["+"] = osc_copy,["*"] = osc_copy },
        paste = { ["+"] = simple_paste,["*"] = simple_paste },
      }
    end
  elseif in_linux then
    vim.g.clipboard = {
      name = "linux-clip",
      copy = { ["+"] = osc_copy,["*"] = osc_copy },
      -- This is a simple paste function. It does not interact with system clipboard.
      paste = { ["+"] = simple_paste,["*"] = simple_paste },
    }
  elseif in_macos then
    vim.g.clipboard = {
      name = "mac-clip",
      copy = { ["+"] = osc_copy,["*"] = osc_copy },
      paste = { ["+"] = "pbpaste",["*"] = "pbpaste" },
    }
  end
end
return M
