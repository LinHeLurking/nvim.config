if vim.g.vscode ~= nil then
  return
end

require("plugin-config.lsp.mason-config").setup()
require("plugin-config.lsp.null-ls-config").setup()
require("mason-null-ls").setup()
require("plugin-config.lsp.mason-lsp-config").setup()
require("plugin-config.lsp.lsp-signature-config").setup()
require("plugin-config.lsp.dressing-config").setup()
require("plugin-config.lsp.nvim-navic-config").setup()
