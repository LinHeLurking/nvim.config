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
  })

  -- Nvim Tree File Explorer
  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
  })

  -- Buffer Line
  use({
    "akinsho/bufferline.nvim",
    tag = "v2.*",
    requires = "kyazdani42/nvim-web-devicons",
  })

  -- LSP
  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("null-ls").setup()
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

  -- Auto complete
  use({
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",
  })

  -- Input Enhance
  use({
    "windwp/nvim-autopairs",
    "windwp/nvim-ts-autotag",
  })

  -- Auto Comment
  use("terrortylor/nvim-comment")

  -- Tree Sitter Syntax Highlight
  use({
    "nvim-treesitter/nvim-treesitter",
    "JoosepAlviste/nvim-ts-context-commentstring",
  })

  -- Telescope
  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    requires = { {
      "nvim-lua/plenary.nvim",
    } },
  })
  use({
    "nvim-telescope/telescope-project.nvim",
    reuquires = {
      "nvim-telescope/telescope-file-browser.nvim",
    },
  })
  use({ "nvim-telescope/telescope-file-browser.nvim" })

  -- Hop Anywehre
  use({
    "phaazon/hop.nvim",
    -- branch = "v2", -- optional but strongly recommended
    config = function()
      require("hop").setup({})
    end,
  })

  -- Terminal
  use({
    "akinsho/toggleterm.nvim",
    tag = "*",
  })

  -- OSC52 Support(Copy & paste through terminal. Easy integration with Windows.)
  use("ojroques/nvim-osc52")

  -- Dashboard
  use({ "glepnir/dashboard-nvim" })
end)
