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
  })

  -- Tokyo Night Theme
  use({
    "folke/tokyonight.nvim",
    config = function()
      require("plugin-config.tokyonight-config")
    end,
  })

  -- Auto indent
  use({
    "nmac427/guess-indent.nvim",
    config = function()
      require("plugin-config.guess-indent-config")
    end,
  })

  -- Hop (Easymotion)
  use({
    "phaazon/hop.nvim",
    branch = "v2", -- optional but strongly recommended
    config = function()
      require("plugin-config.hop-config")
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
  })

  -- Buffer Line
  use({
    "akinsho/bufferline.nvim",
    tag = "v2.*",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("plugin-config.buffer-line-config")
    end,
  })

  -- LSP
  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("plugin-config.null-ls-config")
    end,
    requires = { "nvim-lua/plenary.nvim" },
  })
  use({
    "jayp0521/mason-null-ls.nvim",
    config = function()
      require("mason-null-ls").setup()
    end,
    requires = "williamboman/mason.nvim",
  })
  use({
    "williamboman/mason.nvim",
    requires = {
      "SmiteshP/nvim-navic",
    },
    config = function()
      require("plugin-config.mason-config")
    end,
  })
  use({
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("plugin-config.mason-lsp-config")
    end,
    requires = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  })
  use({
    "neovim/nvim-lspconfig",

  })
  -- LSP Enhance
  use({
    "stevearc/dressing.nvim",
    config = function()
      require("plugin-config.dressing-config")
    end,
  })
  use({
    "SmiteshP/nvim-navic",
    config = function()
      require("plugin-config.nvim-navic-config")
    end,
  })
  -- LSP rust-tools
  use({
    "simrat39/rust-tools.nvim",
    requires = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
  })
  -- Signature help when completing
  use({
    "ray-x/lsp_signature.nvim",
    config = function()
      require("plugin-config.lsp-signature-config")
    end,
  })

  -- DAP
  use({
    "mfussenegger/nvim-dap",
    config = function()
      require("plugin-config.dap-config")
    end,
  })
  use({
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require("plugin-config.dapui-config")
    end,
  })
  use({
    "rcarriga/cmp-dap",
    requires = { "mfussenegger/nvim-dap" },
  })
  use({
    "theHamsta/nvim-dap-virtual-text",
    requires = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("plugin-config.dap-virtual-text-config")
    end,
  })

  -- Trouble
  -- Lua
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("plugin-config.trouble-config")
    end,
  })
  use({
    "kyazdani42/nvim-web-devicons",

  })

  -- Auto complete
  use({
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugin-config.nvim-cmp-config")
    end,
  })
  use({
    "hrsh7th/cmp-nvim-lsp",

  })
  use({
    "hrsh7th/cmp-buffer",

  })
  use({
    "hrsh7th/cmp-path",

  })
  use({
    "hrsh7th/cmp-cmdline",

  })
  use({
    "hrsh7th/cmp-vsnip",

  })
  use({
    "hrsh7th/vim-vsnip",

  })

  -- Input Enhance
  use({
    "windwp/nvim-autopairs",
    requires = "hrsh7th/nvim-cmp",
    config = function()
      require("plugin-config.autopairs-config")
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
  })

  -- Tree Sitter Syntax Highlight
  use({
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("plugin-config.treesitter-config")
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
  })
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    requires = {
      "nvim-treesitter/nvim-treesitter",
    },
  })

  -- Auto Comment
  use({
    "terrortylor/nvim-comment",
    config = function()
      require("plugin-config.comment-config")
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
  })
  -- use({
  --   "nvim-telescope/telescope-project.nvim",
  --   requires = {
  --     "nvim-telescope/telescope-file-browser.nvim",
  --     "nvim-telescope/telescope.nvim",
  --   },
  -- })
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
  })

  -- Terminal
  use({
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("plugin-config.terminal-config")
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
  })

  -- CMake
  use({
    "Civitasv/cmake-tools.nvim",
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require("plugin-config.cmake-config")
    end,
  })

  -- NVim Surround
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("plugin-config.nvim-surround-config")
    end,
  })
end)
