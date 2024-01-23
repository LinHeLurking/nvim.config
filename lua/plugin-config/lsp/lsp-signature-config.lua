local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end
  
  local keymap = require("keymap")
  
  -- Function/Method signature help when completing
  require("lsp_signature").setup({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
      border = "rounded",
    },
    floating_window = false,
    select_signature_key = keymap.signature_help_select_next, -- cycle to next signature, e.g. '<M-n>' function overloading
    hint_prefix = "🥺 ",                                   -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
  })
  
end

return M
