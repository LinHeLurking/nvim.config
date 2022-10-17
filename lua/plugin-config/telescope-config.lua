local telescope = require("telescope")
telescope.load_extension("project")
--telescope.load_extension("frecency")
telescope.setup({
  --  extensions = {
  --    frecency = {
  --      show_scores = false,
  --      show_unindexed = true,
  --      ignore_patterns = { "*.git/*", "*/tmp/*" },
  --      disable_devicons = false,
  --    },
  --  },
  project = {
    hidden_files = true, -- default: false
    theme = "dropdown",
    order_by = "recent",
    sync_with_nvim_tree = true, -- default false
  },
})
local keymap = require("keymap")
keymap.telscope_set_map()
