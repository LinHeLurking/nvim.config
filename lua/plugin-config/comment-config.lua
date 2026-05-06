local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end


  require("nvim_comment").setup({})

  -- Prefer // in C/C++ comments
  vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
    pattern = { "*.c", "*.cpp", "*.cxx", "*.cc", "*.h", "*.hpp" },
    callback = function()
      -- print("Set C/C++ commentstring")
      vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
    end,
  })
end

return M
