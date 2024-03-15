local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end

  local telescope = require("telescope")

  telescope.setup()

  local keymap = require("keymap")
  keymap.telscope_set_map()
end

return M
