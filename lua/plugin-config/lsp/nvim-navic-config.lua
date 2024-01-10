if vim.g.vscode ~= nil then
  return
end

-- 
-- Naciv
--
local navic = require("nvim-navic")
navic.setup({
  highlight = false,
  separator = " > ",
  depth_limit = 0,
  depth_limit_indicator = "..",
})

