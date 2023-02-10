local npairs = require("nvim-autopairs")
--local Rule=require("nvim-autopairs.rule")

npairs.setup({
  check_ts = true,
  disable_filetype = { "dap-repl" },
})
