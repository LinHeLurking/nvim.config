local telescope = require("telescope")

telescope.setup({
  extensions = {
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      -- hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
    project = {
      hidden_files = false, -- default: false
      -- theme = "dropdown",
      order_by = "recent",
      sync_with_nvim_tree = true, -- default false
    },
  },
})

telescope.load_extension("project")
telescope.load_extension("file_browser")

local keymap = require("keymap")
keymap.telscope_set_map()
