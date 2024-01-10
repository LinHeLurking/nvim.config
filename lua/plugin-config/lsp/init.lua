if vim.g.vscode ~= nil then
  return
end

require("plugin-config.lsp.mason-config")
require("plugin-config.lsp.null-ls-config")
require("mason-null-ls").setup()
require("plugin-config.lsp.mason-lsp-config")
require("plugin-config.lsp.lsp-signature-config")
require("plugin-config.lsp.dressing-config")
require("plugin-config.lsp.nvim-navic-config")
