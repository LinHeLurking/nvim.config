local M = {}
M.setup = function()
  -- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  -- Globally override LSP floating window.
  require("lspconfig.ui.windows").default_options.border = "single"

  -- Disable some annoying lsp ui.
  vim.diagnostic.config({
    underline = {
      severity = { min = vim.diagnostic.severity.WARN },
    },
    virtual_text = {
      severity = { min = vim.diagnostic.severity.INFO },
    },
  })
end
return M
