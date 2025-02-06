local M = {}

M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end

  require("hop").setup({
    keys = "etovxqpdygfblzhckisuran",
    uppercase_labels = true,
  })
end

return M
