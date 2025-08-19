--  This file contains all AI related configs, which are not regular plugins.

local M = {}

local _prefered_provider = "claude"
local _providers = {}

local list_providers = function ()
  local dashscope_api_key = os.getenv("DASHSCOPE_API_KEY")
  if dashscope_api_key then
    _providers["qwen"] = {
      __inherited_from = "openai",
      api_key_name = "DASHSCOPE_API_KEY",
      endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1",
      model = "qwen-coder-plus-latest",
    } 
    _prefered_provider = "qwen_coder"
  end
  if os.getenv("MOONSHOT_API_KEY") then
    -- My moonshot API key is created in `.cn` site.
    _providers["moonshot"] = {
      __inherited_from = "openai",
      endpoint = "https://api.moonshot.cn/v1",
      model = "kimi-k2-0711-preview",
      api_key_name = "MOONSHOT_API_KEY",
    }
    _prefered_provider = "moonshot"
  end
end
list_providers()

M.avante_config = {
  "yetone/avante.nvim",
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make BUILD_FROM_SOURCE=true",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- add any opts here
    -- for example
    -- provider = _prefered_provider,
    provider = _prefered_provider,
    providers = _providers,
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick",       -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp",            -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua",            -- for file_selector provider fzf
    "stevearc/dressing.nvim",      -- for input provider dressing
    "folke/snacks.nvim",           -- for input provider snacks
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua",      -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}

return M
