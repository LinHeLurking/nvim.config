vim.opt.timeoutlen = 300

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.scrolloff = 5

vim.opt.clipboard = "unnamedplus"

-- Tab sizes are better managed by plugins automatically

if vim.loop.os_uname().sysname == "Windows_NT" then
  vim.opt.shell = vim.fn.executable("pwsh") and "pwsh" or "powershell"
  vim.opt.shellcmdflag =
  "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.showmatch = true
