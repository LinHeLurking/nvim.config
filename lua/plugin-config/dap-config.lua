local dap = require("dap")

-- Test lldb & lldb-vscode
local has_lldb = vim.fn.executable("lldb") == 1
local lldb_vscode = nil
if has_lldb then
  local handle = io.popen("lldb -v")
  if handle then
    local result = handle:read("*a")
    local main_ver = string.match(result, "%d+")
    local full_ver = string.match(result, "%d+%.%d+%.%d+")
    if vim.fn.executable("lldb-vscode-" .. main_ver) == 1 then
      lldb_vscode = "lldb-vscode-" .. main_ver
      -- print("Using " .. lldb_vscode)
    elseif vim.fn.executable("lldb-vscode-" .. full_ver) == 1 then
      lldb_vscode = "lldb-vscode-" .. full_ver
    elseif vim.fn.executable("lldb-vscode") == 1 then
      lldb_vscode = "lldb-vscode"
    end
    handle:close()
  end
end

if lldb_vscode ~= nil then
  -- Adapter
  dap.adapters.lldb = {
    type = "executable",
    command = "/usr/bin/" .. lldb_vscode, -- adjust as needed, must be absolute path
    name = "lldb",
  }

  -- Language Specific Configuration
  dap.configurations.cpp = {
    {
      name = "Launch",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
      -- 💀
      -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
      --
      --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
      --
      -- Otherwise you might get the following error:
      --
      --    Error on launch: Failed to attach to the target process
      --
      -- But you should be aware of the implications:
      -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
      -- runInTerminal = false,
    },
  }

  -- If you want to use this for Rust and C, add something like this:

  dap.configurations.c = dap.configurations.cpp
  dap.configurations.rust = dap.configurations.cpp
end
