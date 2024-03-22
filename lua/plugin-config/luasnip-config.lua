local M = {}
M.setup = function()
  require("luasnip").setup({
    history = true,
    updateevents = "TextChanged,TextChangedI"
  })
end
return M
