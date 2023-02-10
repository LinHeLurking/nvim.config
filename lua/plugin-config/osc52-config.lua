local M = {}

M.setup = function()
  require("osc52").setup({
    max_length = 0, -- Maximum length of selection (0 for no limit)
    silent = false, -- Disable message on successful copy
    trim = false, -- Trim text before copy
  })
end

return M
