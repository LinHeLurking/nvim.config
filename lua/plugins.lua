local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()
return require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  -- Which Key
  use({
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end,
    -- Load in vscode!
  })

  -- Lualine
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", "SmiteshP/nvim-navic" },
    config = function()
      require("plugin-config.lualine-config")
    end,
    cond = util.is_not_in_vscode,
  })

  -- Tokyo Night Theme
  use({
    "folke/tokyonight.nvim",
    config = function()
      require("plugin-config.tokyonight-config")
    end,
    cond = util.is_not_in_vscode,
  })

  -- Auto indent
  use({
    "nmac427/guess-indent.nvim",
    config = function()
      require("plugin-config.guess-indent-config")
    end,
    cond = util.is_not_in_vscode,
  })

  -- Nvim Tree File Explorer
  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    config = function()
      require("plugin-config.nvim-tree-config")
    end,
    cond = util.is_not_in_vscode,
  })

  -- Buffer Line
  use({
    "akinsho/bufferline.nvim",
    tag = "v2.*",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("plugin-config.buffer-line-config")
    end,
    cond = util.is_not_in_vscode,
  })

  -- LSP

  use({
    -- Basic LSP
    {
      "neovim/nvim-lspconfig",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = util.is_not_in_vscode,
    },
    -- Mason
    {
      "williamboman/mason.nvim",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = util.is_not_in_vscode,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = util.is_not_in_vscode,
    },
    -- Null-ls
    -- "jose-elias-alvarez/null-ls.nvim",
    {
      "nvimtools/none-ls.nvim",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = util.is_not_in_vscode,
    },
    {
      "jay-babu/mason-null-ls.nvim",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = util.is_not_in_vscode,
    },
    -- Signature help when completing
    {
      "ray-x/lsp_signature.nvim",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = util.is_not_in_vscode,
    },
    -- Pretty ui when renaming
    {
      "stevearc/dressing.nvim",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = util.is_not_in_vscode,
    },
    -- Code navigation at status bar
    {
      "SmiteshP/nvim-navic",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = util.is_not_in_vscode,
    },
    -- Rust tools
    {
      "simrat39/rust-tools.nvim",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = util.is_not_in_vscode,
    },
    -- Many LSP related thing won't be correctly configured here.
    -- Configure them in init.lua instead.
  })

  -- Trouble
  -- Lua
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("plugin-config.trouble-config")
    end,
    cond = util.is_not_in_vscode,
  })
  use({
    "kyazdani42/nvim-web-devicons",
    cond = util.is_not_in_vscode,
  })

  -- Auto complete
  use({
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugin-config.nvim-cmp-config")
    end,
    cond = util.is_not_in_vscode,
  })
  use({
    "hrsh7th/cmp-nvim-lsp",
    cond = util.is_not_in_vscode,
  })
  use({
    "hrsh7th/cmp-buffer",
    cond = util.is_not_in_vscode,
  })
  use({
    "hrsh7th/cmp-path",
    cond = util.is_not_in_vscode,
  })
  use({
    "hrsh7th/cmp-cmdline",
    cond = util.is_not_in_vscode,
  })
  use({
    "hrsh7th/cmp-vsnip",
    cond = util.is_not_in_vscode,
  })
  use({
    "hrsh7th/vim-vsnip",
    cond = util.is_not_in_vscode,
  })

  -- Input Enhance
  use({
    "windwp/nvim-autopairs",
    requires = "hrsh7th/nvim-cmp",
    config = function()
      require("plugin-config.autopairs-config")
    end,
    cond = util.is_not_in_vscode,
  })
  use({
    "windwp/nvim-ts-autotag",
    requires = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("plugin-config.nvim-ts-autotag-config")
    end,
    cond = util.is_not_in_vscode,
  })

  -- Tree Sitter Syntax Highlight
  use({
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("plugin-config.treesitter-config")
    end,
    cond = util.is_not_in_vscode,
  })
  use({
    "JoosepAlviste/nvim-ts-context-commentstring",
    requires = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("plugin-config.ts-context-comment-config")
    end,
    cond = util.is_not_in_vscode,
  })
  use({
    "Wansmer/treesj",
    requires = { "nvim-treesitter" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
      })
    end,
    cond = util.is_not_in_vscode,
  })

  -- Auto Comment
  use({
    "terrortylor/nvim-comment",
    config = function()
      require("plugin-config.comment-config")
    end,
    cond = util.is_not_in_vscode,
  })

  -- Telescope
  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    requires = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("plugin-config.telescope-config")
    end,
    cond = util.is_not_in_vscode,
  })
  use({
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    cond = util.is_not_in_vscode,
  })

  -- OSC52 supper for better copy action (in SSH)
  use({
    "ojroques/nvim-osc52",
    config = function()
      require("plugin-config.osc52-config")
    end,
    cond = util.is_not_in_vscode,
  })

  -- Terminal
  use({
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("plugin-config.terminal-config")
    end,
    cond = util.is_not_in_vscode,
  })

  -- Dashboard
  use({
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    requires = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugin-config.dashboard-config")
    end,
    cond = util.is_not_in_vscode,
  })

  -- CMake
  use({
    "Civitasv/cmake-tools.nvim",
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require("plugin-config.cmake-config")
    end,
    cond = util.is_not_in_vscode,
  })

  -- NVim Surround
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("plugin-config.nvim-surround-config")
    end,
    cond = util.is_not_in_vscode,
  })

  -- Git
  -- use("f-person/git-blame.nvim")
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("plugin-config.git")
    end,
    cond = util.is_not_in_vscode,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
