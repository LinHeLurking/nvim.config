local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end

  -- all default
  require("dressing").setup({})
end

return M
