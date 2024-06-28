local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end

  local keymap = require("keymap")

  require("trouble").setup({
    keys = keymap.trouble_keys,
  })
end

return M
