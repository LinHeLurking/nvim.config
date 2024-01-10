require("base")
require("keymap")
require("plugins")
require("plugin-config.clipboard-config")

if not vim.g.vscode then
  require("plugin-config.ui-config")

  -- LSP
  require("plugin-config.lsp.init")
end
