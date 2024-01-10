require("base")
require("keymap")
require("plugins")

if vim.g.vscode then
  return
end

require("plugin-config.clipboard-config")
require("plugin-config.ui-config")

-- LSP
require("plugin-config.lsp.init")
