local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end
  
  
  -- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })
  
  -- Globally override LSP floating window.
  require("lspconfig.ui.windows").default_options.border = "single"
  
  -- Set null-ls window border
  -- This field is set in `lsp-config.lua`
  
  -- vim.cmd("hi link DapUIVariable Normal")

end
return M
