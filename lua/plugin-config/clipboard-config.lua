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

  -- placeholder to prevent matching extra provider
  local function useless_copy(lines, _)
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

    if not in_vscode then
      vim.g.clipboard = {
        name = "wsl-clip",
        copy = { ["+"] = osc_copy,["*"] = osc_copy },
        paste = { ["+"] = wsl_paste,["*"] = wsl_paste },
      }
    else
      vim.g.clipboard = {
        name = "vsc-clip",
        copy = { ["+"] = useless_copy,["*"] = useless_copy },
        paste = { ["+"] = simple_paste,["*"] = simple_paste },
      }
      -- when neovim is used behind vscode, force sync clipboard.
      local clip = "/mnt/c/WINDOWS/system32/clip.exe"
      if vim.fn.executable(clip) then
        vim.cmd([[
          augroup WSLYank
          autocmd!
          autocmd TextYankPost * if v:event.operator ==# 'y' | call system("iconv -t utf16 | /mnt/c/WINDOWS/system32/clip.exe", @0) | endif
          augroup END
        ]])
      end
    end
  elseif in_windows then
    vim.g.clipboard = {
      name = "win-clip",
      copy = { ["+"] = osc_copy,["*"] = osc_copy },
      paste = { ["+"] = simple_paste,["*"] = simple_paste },
    }
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
