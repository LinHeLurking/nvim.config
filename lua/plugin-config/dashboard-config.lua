local home = os.getenv("HOME")
local db = require("dashboard")
local keymap = require("keymap")

local icon_color = "Function"

db.session_directory = vim.fn.stdpath("data") .. "/sessions"

db.custom_center = {
  {
    icon = "  ",
    desc = "Recent Files                            ",
    shortcut = "r    ",
    action = "Telescope oldfiles",
    icon_hl = { link = icon_color },
  },
  {
    icon = "  ",
    desc = "Find Files                              ",
    shortcut = "f    ",
    action = "Telescope find_files",
    icon_hl = { link = icon_color },
  },
  {
    icon = "  ",
    desc = "Open Project                            ",
    shortcut = "p   ",
    action = "Telescope project",
    icon_hl = { link = icon_color },
  },
  {
    desc = "New File                                ",
    shortcut = "n    ",
    icon = "ﱐ  ",
    action = "DashboardNewFile",
    icon_hl = { link = icon_color },
  },
  {
    desc = "Update Plugins                          ",
    shortcut = "u    ",
    icon = "  ",
    action = "PackerUpdate",
    icon_hl = { link = icon_color },
  },
  {
    desc = "Setting                                 ",
    shortcut = "s    ",
    icon = "  ",
    action = "edit " .. home .. "/.config/nvim/",
    icon_hl = { link = icon_color },
  },
  {
    desc = "Exit                                    ",
    shortcut = "q    ",
    icon = "  ",
    action = "exit",
    icon_hl = { link = icon_color },
  },
}

vim.api.nvim_create_autocmd("Filetype", {
  pattern = "dashboard",
  group = vim.api.nvim_create_augroup("Dashboard_au", { clear = true }),
  callback = keymap.dashboard_set_map,
})
