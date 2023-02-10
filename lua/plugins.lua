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
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  })

  -- Tokyo Night Theme
  use("folke/tokyonight.nvim")

  -- Auto indent
  use({
    "nmac427/guess-indent.nvim",
    config = function()
      require("plugin-config.guess-indent-config").setup()
    end,
  })

  -- Hop (Easymotion)
  use({
    "phaazon/hop.nvim",
    branch = "v2", -- optional but strongly recommended
    config = function()
      require("plugin-config.hop-config").setup()
    end,
  })

  -- Nvim Tree File Explorer
  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    config = function()
      require("plugin-config.nvim-tree-config").setup()
    end,
  })

  -- Buffer Line
  use({
    "akinsho/bufferline.nvim",
    tag = "v2.*",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("plugin-config.buffer-line-config").setup()
    end,
  })

  -- LSP
  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("plugin-config.lsp-config").setup()
    end,
    requires = { "nvim-lua/plenary.nvim" },
  })
  use({
    "jayp0521/mason-null-ls.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  })
  -- LSP Enhance
  use({ "stevearc/dressing.nvim" })
  use({ "SmiteshP/nvim-navic" })
  -- LSP rust-tools
  use({
    "simrat39/rust-tools.nvim",
    requires = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
  })

  -- DAP
  use({
    "mfussenegger/nvim-dap",
    config = function()
      require("plugin-config.dap-config").setup()
    end,
  })
  use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
  use({ "rcarriga/cmp-dap", requires = { "mfussenegger/nvim-dap" } })
  use({
    "theHamsta/nvim-dap-virtual-text",
    requires = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
  })

  -- Trouble
  -- Lua
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("plugin-config.trouble-config").setup()
    end,
  })
  use({ "kyazdani42/nvim-web-devicons" })

  -- Auto complete
  use({
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",
    config = function()
      require("plugin-config.nvim-cmp-config").setup()
    end,
  })

  -- Input Enhance
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("plugin-config.autopairs-config").setup()
    end,
  })
  use({
    "windwp/nvim-ts-autotag",
    config = function()
      require("plugin-config.nvim-ts-autotag-config").setup()
    end,
  })

  -- Auto Comment
  use({
    "terrortylor/nvim-comment",
    config = function()
      require("plugin-config.comment-config").setup()
    end,
  })

  -- Tree Sitter Syntax Highlight
  use({
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("plugin-config.treesitter-config").setup()
    end,
  })
  use({
    "JoosepAlviste/nvim-ts-context-commentstring",
    requires = {
      "nvim-treesitter/nvim-treesitter",
    },
  })
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    requires = {
      "nvim-treesitter/nvim-treesitter",
    },
  })

  -- Telescope
  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    requires = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("plugin-config.telescope-config").setup()
    end,
  })
  use({
    "nvim-telescope/telescope-project.nvim",
    requires = {
      "nvim-telescope/telescope-file-browser.nvim",
    },
  })
  use({ "nvim-telescope/telescope-file-browser.nvim" })

  -- OSC52 supper for better copy action (in SSH)
  use({
    "ojroques/nvim-osc52",
    config = function()
      require("plugin-config.osc52-config").setup()
    end,
  })

  -- Terminal
  use({
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("plugin-config.terminal-config").setup()
    end,
  })

  -- Dashboard
  use({
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    requires = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugin-config.dashboard-config").setup()
    end,
  })

  -- CMake
  use({
    "Civitasv/cmake-tools.nvim",
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require("plugin-config.cmake-config").setup()
    end,
  })

  -- NVim Surround
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("plugin-config.nvim-surround-config").setup()
    end,
  })
end)
