local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end
  
  require("mason").setup({
    ui = {
      border = "single",
    },
  })
end

return M
