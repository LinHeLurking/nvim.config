local M = {}

local bootstrap_lazy = function()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

local get_plugins = function()
  local is_vsc = vim.g.vscode ~= nil
  local not_vsc = not is_vsc
  local plugins = {
    -- which key
    { "folke/which-key.nvim" },
    -- nvim surround
    {
      "kylechui/nvim-surround",
      version = "*",
      config = function()
        require("plugin-config.nvim-surround-config").setup()
      end,
    },
    -- OSC52 clipboard support
    {
      "ojroques/nvim-osc52",
      config = function()
        require("plugin-config.osc52-config")
      end,
    },
    --
    -- everything below will not be loaded when in vscode
    --
    -- lualine
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "kyazdani42/nvim-web-devicons", "SmiteshP/nvim-navic" },
      config = function()
        require("plugin-config.lualine-config").setup()
      end,
      cond = not_vsc,
    },
    -- tokyonight theme
    {
      "folke/tokyonight.nvim",
      config = function()
        require("plugin-config.tokyonight-config").setup()
      end,
      cond = not_vsc,
    },
    -- guess indent
    {
      "nmac427/guess-indent.nvim",
      config = function()
        require("plugin-config.guess-indent-config").setup()
      end,
      cond = not_vsc,
      lazy = true,
      cmd = "GuessIndent",
    },
    -- nvim tree file explorer
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = {
        "nvim-tree/nvim-web-devicons", -- optional, for file icons
      },
      config = function()
        require("plugin-config.nvim-tree-config").setup()
      end,
      cond = not_vsc,
    },
    -- buffer line
    {
      "akinsho/bufferline.nvim",
      version = "*",
      dependencies = "kyazdani42/nvim-web-devicons",
      config = function()
        require("plugin-config.buffer-line-config").setup()
      end,
      cond = not_vsc,
    },
    --
    -- LSP related settings
    --
    -- basic LSP
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "neovim/nvim-lspconfig",
      },
      config = function()
        require("plugin-config.lsp.basic-lsp").setup()
      end,
      cond = not_vsc,
    },
    -- mason
    {
      "williamboman/mason.nvim",
      dependencies = {
        "neovim/nvim-lspconfig",
      },
      config = function()
        require("plugin-config.lsp.mason-config").setup()
      end,
      cond = not_vsc,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = {
        "neovim/nvim-lspconfig",
      },
      config = function()
        require("plugin-config.lsp.mason-lsp-config").setup()
      end,
      cond = not_vsc,
    },
    -- null-ls
    {
      "nvimtools/none-ls.nvim",
      dependencies = {
        "neovim/nvim-lspconfig",
        "nvimtools/none-ls-extras.nvim",
      },
      config = function()
      end,
      cond = not_vsc,
    },
    {
      "jay-babu/mason-null-ls.nvim",
      dependencies = {
        "neovim/nvim-lspconfig",
        "nvimtools/none-ls.nvim",
      },
      config = function()
        require("plugin-config.lsp.null-ls-config").setup()
      end,
      cond = not_vsc,
    },
    -- signature help when completing
    {
      "ray-x/lsp_signature.nvim",
      dependencies = {
        "neovim/nvim-lspconfig",
      },
      config = function()
        require("plugin-config.lsp.lsp-signature-config").setup()
      end,
      cond = not_vsc,
    },
    -- pretty ui when renaming
    {
      "stevearc/dressing.nvim",
      dependencies = {
        "neovim/nvim-lspconfig",
      },
      config = function()
        require("plugin-config.lsp.dressing-config").setup()
      end,
      cond = not_vsc,
    },
    -- code navigation at status bar
    {
      "SmiteshP/nvim-navic",
      requires = {
        "neovim/nvim-lspconfig",
      },
      config = function()
        require("plugin-config.lsp.nvim-navic-config").setup()
      end,
      cond = not_vsc,
    },
    -- rust tools
    {
      "simrat39/rust-tools.nvim",
      requires = {
        "neovim/nvim-lspconfig",
      },
      cond = not_vsc,
      lazy = true,
    },
    -- trouble
    {
      "folke/trouble.nvim",
      dependencies = "kyazdani42/nvim-web-devicons",
      config = function()
        require("plugin-config.trouble-config").setup()
      end,
      cond = not_vsc,
      lazy = true,
      cmd = "TroubleToggle",
    },
    -- auto complete related settings
    {
      "hrsh7th/nvim-cmp",
      config = function()
        require("plugin-config.nvim-cmp-config").setup()
      end,
      cond = not_vsc,
    },
    {
      "hrsh7th/cmp-nvim-lsp",
      cond = not_vsc,
    },
    {
      "hrsh7th/cmp-buffer",
      cond = not_vsc,
    },
    {
      "hrsh7th/cmp-path",
      cond = not_vsc,
    },
    {
      "hrsh7th/cmp-cmdline",
      cond = not_vsc,
    },
    {
      "hrsh7th/cmp-vsnip",
      cond = not_vsc,
    },
    {
      "hrsh7th/vim-vsnip",
      cond = not_vsc,
    },
    -- input enhance
    {
      "windwp/nvim-autopairs",
      dependencies = "hrsh7th/nvim-cmp",
      config = function()
        require("plugin-config.autopairs-config").setup()
      end,
      cond = not_vsc,
    },
    {
      "windwp/nvim-ts-autotag",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("plugin-config.nvim-ts-autotag-config").setup()
      end,
      cond = not_vsc,
    },
    -- tree sitter syntax highlight
    {
      "nvim-treesitter/nvim-treesitter",
      config = function()
        require("plugin-config.treesitter-config").setup()
      end,
      cond = not_vsc,
    },
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("plugin-config.ts-context-comment-config").setup()
      end,
      cond = not_vsc,
      lazy = true,
    },
    -- auto comment
    {
      "terrortylor/nvim-comment",
      config = function()
        require("plugin-config.comment-config").setup()
      end,
      cond = not_vsc,
      lazy = true,
      cmd = "CommentToggle",
    },
    -- telescope
    {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      config = function()
        require("plugin-config.telescope-config").setup()
      end,
      cond = not_vsc,
    },
    -- terminal
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
        require("plugin-config.terminal-config").setup()
      end,
      cond = not_vsc,
      lazy = true,
      cmd = "ToggleTerm",
      keys = { "<F60>", "<A-F12>" }
    },
    -- dashboard
    {
      "glepnir/dashboard-nvim",
      event = "VimEnter",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("plugin-config.dashboard-config").setup()
      end,
      cond = not_vsc,
    },
    -- git
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("plugin-config.git").setup()
      end,
      cond = not_vsc,
    },
  }
  return plugins
end

M.setup = function()
  bootstrap_lazy()
  require("lazy").setup(get_plugins())
end

-- return M
M.setup()
