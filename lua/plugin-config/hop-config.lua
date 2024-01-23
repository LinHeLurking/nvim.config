local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end
  
  require("hop").setup({})
end

return M
