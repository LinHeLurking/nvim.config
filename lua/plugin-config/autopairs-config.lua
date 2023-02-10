local npairs = require("nvim-autopairs")
--local Rule=require("nvim-autopairs.rule")

local M = {}

M.setup = function()
  npairs.setup({
    check_ts = true,
    disable_filetype = { "dap-repl" },
  })
end

return M
