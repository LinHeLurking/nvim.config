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

  local function set_yank_autocmd()
    local clip = nil
    if in_wsl then
      clip = "/mnt/c/WINDOWS/system32/clip.exe"
    else
      clip = "clip.exe"
    end
    local clip_cmd = [["iconv -t utf16 | sed \"1s/^\\xFF\\xFE//\" | ]] .. clip .. "\""
    local autogroup_cmd = [[
          augroup YankClipEXE
          autocmd!
        ]] .. "autocmd TextYankPost * call system(" .. clip_cmd .. ", @0)\n" .. [[
          augroup END
        ]]

    if clip and vim.fn.executable(clip) then
      vim.cmd(autogroup_cmd)
    end
  end

  --
  if in_vscode then
    vim.g.clipboard = {
      name = "vsc-clip",
      copy = { ["+"] = useless_copy, ["*"] = useless_copy },
      paste = { ["+"] = simple_paste, ["*"] = simple_paste },
    }
    set_yank_autocmd()
  elseif in_wsl then
    local home = os.getenv("HOME")
    local wsl_paste = { home .. "/.config/nvim/sh/nvim_paste.sh" }
    vim.g.clipboard = {
      name = "wsl-clip",
      copy = { ["+"] = osc_copy, ["*"] = osc_copy },
      paste = { ["+"] = wsl_paste, ["*"] = wsl_paste },
    }
  else
    vim.g.clipboard = {
      name = "general-clip",
      copy = { ["+"] = osc_copy, ["*"] = osc_copy },
      paste = { ["+"] = simple_paste, ["*"] = simple_paste },
    }
  end
end

-- return M
M.setup()
