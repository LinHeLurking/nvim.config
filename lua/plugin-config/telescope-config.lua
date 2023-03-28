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
      -- theme = "dropdown",
      order_by = "recent",
      sync_with_nvim_tree = true, -- default false
      manual_mode = false,
      -- Methods of detecting the root directory. **"lsp"** uses the native neovim
      -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
      -- order matters: if one is not detected, the other is used as fallback. You
      -- can also delete or rearangne the detection methods.
      detection_methods = { "lsp", "pattern" },
      -- All the patterns used to detect root dir, when **"pattern"** is in
      -- detection_methods
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
      -- Table of lsp clients to ignore by name
      -- eg: { "efm", ... }
      ignore_lsp = {},
      -- Don't calculate root dir on specific directories
      -- Ex: { "~/.cargo/*", ... }
      exclude_dirs = {},
      -- Show hidden files in telescope
      show_hidden = true,
      -- When set to false, you will get a message when project.nvim changes your
      -- directory.
      silent_chdir = true,
      -- Path where project.nvim will store the project history for use in
      -- telescope
      datapath = vim.fn.stdpath("data"),
    },
  },
})

-- telescope.load_extension("project")
telescope.load_extension("file_browser")

local keymap = require("keymap")
keymap.telscope_set_map()
