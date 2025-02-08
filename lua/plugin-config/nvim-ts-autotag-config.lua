local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end

  require("nvim-ts-autotag").setup()

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = {
      severity = { min = vim.diagnostic.severity.WARN },
    },
    virtual_text = {
      severity = { min = vim.diagnostic.severity.ERROR },
    },
    update_in_insert = true,
  })
end

return M
