local home = os.getenv("HOME")
local db = require("dashboard")

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
  callback = function()
    local opts = { noremap = true, silent = true }
    local bset = vim.api.nvim_buf_set_keymap
    bset(0, "n", "f", "<Cmd>Telescope find_files<CR>", opts)
    bset(0, "n", "r", "<Cmd>Telescope oldfiles<CR>", opts)
    bset(0, "n", "n", "<Cmd>DashboardNewFile<CR>", opts)
    bset(0, "n", "u", "<Cmd>PackerUpdate<CR>", opts)
    bset(0, "n", "s", "<Cmd>edit " .. home .. "/.config/nvim<CR>", opts)
    bset(0, "n", "q", "<Cmd>exit<CR>", opts)
  end,
})
