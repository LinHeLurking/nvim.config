
require("nvim_comment").setup({
  hook = function()
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")
    local only_for_these =
    { "vue", "javascript", "typescript", "tsx", "css", "scss", "php", "html", "svelte", "astro", "lua" }
    local enable_ctx_comment = false
    for _, v in ipairs(only_for_these) do
      if filetype == v then
        enable_ctx_comment = true
        break
      end
    end
    if enable_ctx_comment then
      require("ts_context_commentstring.internal").update_commentstring()
    end
  end,
})

-- Prefer // in C/C++ comments
vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
  pattern = { "*.c", "*.cpp", "*.cxx", "*.cc", "*.h", "*.hpp" },
  callback = function()
    -- print("Set C/C++ commentstring")
    vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
  end,
})
