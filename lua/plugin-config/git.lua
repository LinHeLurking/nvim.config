local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end
  
  require("gitsigns").setup({
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 300,
      ignore_whitespace = false,
    },
  })
end

return M
