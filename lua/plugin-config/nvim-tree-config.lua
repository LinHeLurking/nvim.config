local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end


  -- disable netrw at the very start of your init.lua (strongly advised)
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- empty setup using defaults
  -- require("nvim-tree").setup()

  -- OR setup with some options
  require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
      adaptive_size = true,
      width = {
        min = 15,
        max = 35,
        padding = 2,
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
      ignore = false, -- Ignore based on .gitignore file
      show_on_dirs = true,
      timeout = 400,
    },
    filesystem_watchers = {
      enable = true,
      debounce_delay = 100,
      ignore_dirs = {
        "node_modules",
        ".cache",
      },
    },
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = false,
      ignore_list = { "toggleterm", "term", ".cache", "node_modules" },
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

  local function open_nvim_tree(data)
    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    if not directory then
      return
    end

    -- change to the directory
    vim.cmd.cd(data.file)

    -- open the tree
    require("nvim-tree.api").tree.open()
  end

  -- Open tree if vim is opened with a directory
  vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = open_nvim_tree,
  })

  -- Enabling this sometimes mess up buffer lines
  -- vim.api.nvim_command(":NvimTreeOpen")
end
return M
