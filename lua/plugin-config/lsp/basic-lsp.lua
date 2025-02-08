local M = {}
M.setup = function()
	-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	-- Globally override LSP floating window.
	require("lspconfig.ui.windows").default_options.border = "single"

	-- Disable some annoying lsp ui.
	-- Note that ts-autotag plugin also modifies diagnostic settings for sepcial reasons.
	-- See: nvim-ts-autotag-config.lua for details
	vim.diagnostic.config({
		virtual_text = {
			severity = vim.diagnostic.severity.ERROR,
			current_line = true,
		},
		underline = {
			severity = { min = vim.diagnostic.severity.WARN },
		},
	})
end
return M
