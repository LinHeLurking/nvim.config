-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- empty setup using defaults
-- require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = false,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
    custom = { "^.git$" },
  },
  git = {
    enable = true,
    ignore = false,
    show_on_dirs = true,
    timeout = 400,
  },
  -- Integrate with project.nvim
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  -- Profile
  -- log = {
  --   enable = true,
  --   truncate = true,
  --   types = {
  --     diagnostics = true,
  --     git = true,
  --     profile = true,
  --     watcher = true,
  --   },
  -- },
})

-- Automatically close if there's only nvim tree left
-- Copied from https://github.com/nvim-tree/nvim-tree.lua/discussions/1115
-- vim.api.nvim_create_autocmd("BufDelete", {
--   nested = true,
--   callback = function()
--     if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
--       vim.cmd "quit"
--     end
--   end
-- })

-- Open tree if vim is opened with a directory
vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):sub(-1) == "/" then
      vim.api.nvim_command(":NvimTreeOpen")
    end
  end,
})

-- Enabling this sometimes mess up buffer lines
-- vim.api.nvim_command(":NvimTreeOpen")
