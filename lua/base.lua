vim.opt.timeoutlen = 300

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.scrolloff = 5

-- vim.opt.clipboard = "unnamedplus"
vim.opt.clipboard:append("unnamedplus")

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.showmatch = true

-- Tab sizes are better managed by plugins automatically

-- Only set if not in vscode
if not vim.g.vscode then
  if vim.loop.os_uname().sysname == "Windows_NT" then
    vim.opt.shell = vim.fn.executable("pwsh") and "pwsh" or "powershell"
    vim.opt.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
    vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
    vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
  end

  local zsh_test_handler = io.popen("command -v zsh")
  local zsh_ver = zsh_test_handler and zsh_test_handler:read("*a")
  if zsh_ver ~= nil and zsh_ver ~= "" then
    vim.o.shell = "/bin/zsh"
  end

  -- Set python provider if it's in conda
  local conda = os.getenv("CONDA_PREFIX")
  if conda ~= nil and conda ~= "" then
    vim.g.python3_host_prog = conda .. "/bin/python"
  end
end

-- Install `im-select` using scoop:
-- scoop bucket add im-select https://github.com/daipeihust/im-select
-- scoop install im-select 
local has_im_select = vim.fn.executable("im-select.exe")
if has_im_select then
  -- 1033 is english, 2052 is chinese
  vim.api.nvim_command("autocmd VimEnter * !im-select.exe 1033")
  vim.api.nvim_command("autocmd InsertEnter * :silent :!im-select.exe 2052")
  vim.api.nvim_command("autocmd InsertLeave * :silent :!im-select.exe 1033")
  vim.api.nvim_command("autocmd VimLeave * !im-select.exe 2052")
end
