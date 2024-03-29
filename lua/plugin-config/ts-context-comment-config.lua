local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end

  require("ts_context_commentstring").setup({
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  })
  vim.g.skip_ts_context_commentstring_module = true
end

return M
