-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

-- Globally override LSP floating window.
require("lspconfig.ui.windows").default_options.border = "single"

-- Set null-ls window border
-- This field is set in `lsp-config.lua`

-- Change DAP UI colors
vim.cmd("hi link DapUIVariable Normal")
vim.cmd("hi DapUIScope guifg=#064EF0")
vim.cmd("hi DapUIType guifg=#D484FF")
vim.cmd("hi link DapUIValue Normal")
vim.cmd("hi DapUIModifiedValue guifg=#064EF0 gui=bold")
vim.cmd("hi DapUIDecoration guifg=#064EF0")
vim.cmd("hi DapUIThread guifg=#A9FF68")
vim.cmd("hi DapUIStoppedThread guifg=#064EF0")
vim.cmd("hi link DapUIFrameName Normal")
vim.cmd("hi DapUISource guifg=#D484FF")
vim.cmd("hi DapUILineNumber guifg=#064EF0")
vim.cmd("hi link DapUIFloatNormal NormalFloat")
vim.cmd("hi DapUIFloatBorder guifg=#064EF0")
vim.cmd("hi DapUIWatchesEmpty guifg=#F70067")
vim.cmd("hi DapUIWatchesValue guifg=#A9FF68")
vim.cmd("hi DapUIWatchesError guifg=#F70067")
vim.cmd("hi DapUIBreakpointsPath guifg=#064EF0")
vim.cmd("hi DapUIBreakpointsInfo guifg=#A9FF68")
vim.cmd("hi DapUIBreakpointsCurrentLine guifg=#A9FF68 gui=bold")
vim.cmd("hi link DapUIBreakpointsLine DapUILineNumber")
vim.cmd("hi DapUIBreakpointsDisabledLine guifg=#424242")
vim.cmd("hi link DapUICurrentFrameName DapUIBreakpointsCurrentLine")
vim.cmd("hi DapUIStepOver guifg=#064EF0")
vim.cmd("hi DapUIStepInto guifg=#064EF0")
vim.cmd("hi DapUIStepBack guifg=#064EF0")
vim.cmd("hi DapUIStepOut guifg=#064EF0")
vim.cmd("hi DapUIStop guifg=#F70067")
vim.cmd("hi DapUIPlayPause guifg=#A9FF68")
vim.cmd("hi DapUIRestart guifg=#A9FF68")
vim.cmd("hi DapUIUnavailable guifg=#424242")

-- Hide DAP created buffers.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-repl",
  callback = function(args)
    vim.api.nvim_buf_set_option(args.buf, "buflisted", false)
  end,
})
