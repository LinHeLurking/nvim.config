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
local util = require("util")

return require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  -- Which Key
  use({
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end,
  })

  -- Lualine
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", "SmiteshP/nvim-navic" },
    config = function()
      require("plugin-config.lualine-config")
    end,
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })

  -- Tokyo Night Theme
  use({
    "folke/tokyonight.nvim",
    config = function()
      require("plugin-config.tokyonight-config")
    end,
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })

  -- Auto indent
  use({
    "nmac427/guess-indent.nvim",
    config = function()
      require("plugin-config.guess-indent-config")
    end,
    cond = function()
      return vim.g.vscode ~= nil
    end,
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
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })

  -- Buffer Line
  use({
    "akinsho/bufferline.nvim",
    tag = "v2.*",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("plugin-config.buffer-line-config")
    end,
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })

  -- LSP

  use({
    -- Basic LSP
    {
      "neovim/nvim-lspconfig",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = function()
        return vim.g.vscode ~= nil
      end,
    },
    -- Mason
    {
      "williamboman/mason.nvim",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = function()
        return vim.g.vscode ~= nil
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = function()
        return vim.g.vscode ~= nil
      end,
    },
    -- Null-ls
    -- "jose-elias-alvarez/null-ls.nvim",
    {
      "nvimtools/none-ls.nvim",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = function()
        return vim.g.vscode ~= nil
      end,
    },
    {
      "jay-babu/mason-null-ls.nvim",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = function()
        return vim.g.vscode ~= nil
      end,
    },
    -- Signature help when completing
    {
      "ray-x/lsp_signature.nvim",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = function()
        return vim.g.vscode ~= nil
      end,
    },
    -- Pretty ui when renaming
    {
      "stevearc/dressing.nvim",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = function()
        return vim.g.vscode ~= nil
      end,
    },
    -- Code navigation at status bar
    {
      "SmiteshP/nvim-navic",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = function()
        return vim.g.vscode ~= nil
      end,
    },
    -- Rust tools
    {
      "simrat39/rust-tools.nvim",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = function()
        return vim.g.vscode ~= nil
      end,
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
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })
  use({
    "kyazdani42/nvim-web-devicons",
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })

  -- Auto complete
  use({
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugin-config.nvim-cmp-config")
    end,
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })
  use({
    "hrsh7th/cmp-nvim-lsp",
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })
  use({
    "hrsh7th/cmp-buffer",
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })
  use({
    "hrsh7th/cmp-path",
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })
  use({
    "hrsh7th/cmp-cmdline",
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })
  use({
    "hrsh7th/cmp-vsnip",
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })
  use({
    "hrsh7th/vim-vsnip",
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })

  -- Input Enhance
  use({
    "windwp/nvim-autopairs",
    requires = "hrsh7th/nvim-cmp",
    config = function()
      require("plugin-config.autopairs-config")
    end,
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })
  use({
    "windwp/nvim-ts-autotag",
    requires = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("plugin-config.nvim-ts-autotag-config")
    end,
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })

  -- Tree Sitter Syntax Highlight
  use({
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("plugin-config.treesitter-config")
    end,
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })
  use({
    "JoosepAlviste/nvim-ts-context-commentstring",
    requires = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("plugin-config.ts-context-comment-config")
    end,
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })
  use({
    "Wansmer/treesj",
    requires = { "nvim-treesitter" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
      })
    end,
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })

  -- Auto Comment
  use({
    "terrortylor/nvim-comment",
    config = function()
      require("plugin-config.comment-config")
    end,
    cond = function()
      return vim.g.vscode ~= nil
    end,
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
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })
  use({
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
  })

  -- OSC52 supper for better copy action (in SSH)
  use({
    "ojroques/nvim-osc52",
    config = function()
      require("plugin-config.osc52-config")
    end,
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })

  -- Terminal
  use({
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("plugin-config.terminal-config")
    end,
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })

  -- Dashboard
  use({
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    requires = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugin-config.dashboard-config")
    end,
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })

  -- CMake
  use({
    "Civitasv/cmake-tools.nvim",
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require("plugin-config.cmake-config")
    end,
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })

  -- NVim Surround
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("plugin-config.nvim-surround-config")
    end,
    -- cond = function() return vim.g.vscode ~=nil end
  })

  -- Git
  -- use("f-person/git-blame.nvim")
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("plugin-config.git")
    end,
    cond = function()
      return vim.g.vscode ~= nil
    end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
