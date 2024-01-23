require("plugins")
require("base")
require("keymap")
require("plugin-config.clipboard-config").setup()

if not vim.g.vscode then
  require("plugin-config.ui-config")

  -- LSP
  require("plugin-config.lsp.init")
end
