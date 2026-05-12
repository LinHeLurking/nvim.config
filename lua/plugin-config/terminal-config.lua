local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end

  local keymap = require("keymap")

  require("toggleterm").setup({
    -- size can be a number or function which is passed the current terminal
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.45
      end
    end,
    direction = "horizontal",
    open_mapping = [[<C-\>]],
    autochdir = true,
    shade_terminals = false,  -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
    shading_factor = "2",     -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true,   -- whether or not the open mapping applies in insert mode
    terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
    persist_size = true,
    persist_mode = true,      -- if set to true (default) the previous terminal mode will be remembered
    shell = vim.o.shell,      -- change the default shell
    auto_scroll = true,       -- automatically scroll to the bottom on terminal output
    -- This field is only relevant if direction is set to 'float'
  })

  local t_open_cb = function(event)
    keymap.set_term_keymap(event)
    -- Mark toggleterm buffers as not modified to allow :w and :wqa
    vim.bo.buflisted = false
    vim.bo.modified = false
  end

  -- Also mark as unmodified when entering terminal buffer
  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'term://*toggleterm#*',
    callback = function()
      vim.bo.modified = false
    end,
  })

  
  -- Set terminal keymaps.
  vim.api.nvim_create_autocmd("TermOpen", { pattern = { "term://*toggleterm#*" }, callback = t_open_cb })
end

return M
