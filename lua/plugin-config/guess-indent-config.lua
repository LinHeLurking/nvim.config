local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end

  -- This is the default configuration
  require("guess-indent").setup({
    auto_cmd = true, -- Set to false to disable automatic execution
    filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
      "netrw",
      "tutor",
    },
    buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
      "help",
      "nofile",
      "terminal",
      "prompt",
    },
    on_tab_options = { -- A table of vim options when tabs are detected
      ["expandtab"] = false,
    },
    on_space_options = { -- A table of vim options when spaces are detected
      ["expandtab"] = true,
      ["tabstop"] = "detected", -- If the option value is 'detected', The value is set to the automatically detected indent size.
      ["softtabstop"] = "detected",
      ["shiftwidth"] = "detected",
    },
  })
end

return M
