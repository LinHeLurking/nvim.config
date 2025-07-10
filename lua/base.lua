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
vim.opt.foldcolumn = "0" -- '0' is not bad
vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.winborder = "rounded"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.smartindent = true

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
	local zsh_cmd = zsh_test_handler and zsh_test_handler:read("*a")
	if zsh_cmd ~= nil and zsh_cmd ~= "" then
		vim.o.shell = zsh_cmd:gsub("%s*", "")
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
	local switch_eng = function()
		vim.g._old_im = vim.fn.system("im-select.exe")
		vim.cmd(":silent :!im-select.exe 1033")
	end
	local switch_back = function()
		local im = "2052"
		if vim.g._old_im then
			im = vim.g._old_im
		end
		vim.cmd(":silent :!im-select.exe " .. im)
	end
	vim.api.nvim_create_autocmd("VimEnter", { callback = switch_eng })
	vim.api.nvim_create_autocmd("InsertLeave", { callback = switch_eng })
	vim.api.nvim_create_autocmd("InsertEnter", { callback = switch_back })
	vim.api.nvim_create_autocmd("VimLeave", { callback = switch_back })
end

-- Set c++ module file type
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.cppm", "*.ccm", "*.cxxm", "*.c++m" },
	command = "setfiletype cpp",
})
