local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end

  require("cmake-tools").setup({
    cmake_command = "cmake",
    cmake_build_directory = "build",
    cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
    cmake_regenerate_on_save = true,                                               -- Saves CMakeLists.txt file only if modified.
    cmake_soft_link_compile_commands = false,                                      -- if softlink compile commands json file
    cmake_build_options = {},
    cmake_console_size = 10,                                                       -- cmake output window height
    cmake_show_console = "always",                                                 -- "always", "only_on_error"
    cmake_dap_configuration = { name = "cpp", type = "lldb", request = "launch" }, -- dap configuration, optional
    cmake_dap_open_command = require("dap").repl.open,                             -- optional
    cmake_variants_message = {
      short = { show = true },
      long = { show = true, max_length = 40 },
    },
  })
end

return M
