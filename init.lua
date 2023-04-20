require("base")
require("plugins")
require("keymap")
require("plugin-config.clipboard-config")
require("plugin-config.ui-config")

-- Mason related LSP config 
require("plugin-config.mason-config")
require("plugin-config.null-ls-config")
require("mason-null-ls").setup()
require("plugin-config.mason-lsp-config")
require("plugin-config.lsp-signature-config")

