if vim.g.vscode ~= nil then
  return
end

local keymap = require("keymap")

require("dashboard").setup({
  theme = "hyper",   --  theme is doom and hyper default is hyper
  config = {
    shortcut = keymap.dashboard_shortcut,
    packages = { enable = true },   -- show how many plugins neovim loaded
    -- Limit how many projects list, action when you press key or enter it will run this action.
    -- project = { limit = 8, icon = " ", label = "Recent Projects", action = "Telescope project" },
    -- mru = { limit = 10, icon = " Recent Files", label = "" },
    footer = { "", "Keep on keeping on!" },   -- footer
  },
})
