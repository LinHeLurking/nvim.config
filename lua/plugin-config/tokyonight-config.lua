local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end

  -- TokyoNight color scheme
  vim.g.tokyonight_transparent = true
  vim.opt.background = "light"
  require("tokyonight").setup({
    -- your configuration comes here
    -- or leave it empty to use the default settings
    style = "moon",       -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
    light_style = "day",  -- The theme is used when the background is set to light
    transparent = true,   -- Enable this to disable setting the background color
    terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
    styles = {
      -- Style to be applied to different syntax groups
      -- Value is any valid attr-list value for `:help nvim_set_hl`
      comments = { italic = true },
      keywords = { italic = false },
      functions = {},
      variables = {},
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = "transparent",     -- style for sidebars, see below
      floats = "transparent",       -- style for floating windows
    },
    sidebars = { "qf", "help" },    -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
    day_brightness = 0.3,           -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
    hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
    dim_inactive = false,           -- dims inactive windows
    lualine_bold = false,           -- When `true`, section headers in the lualine theme will be bold
    --- You can override specific color groups to use other groups or a hex color
    --- function will be called with a ColorScheme table
    ---@param colors ColorScheme
    on_colors = function(colors)
    end,
    --- You can override specific highlights to use other groups or a hex color
    --- function will be called with a Highlights and ColorScheme table
    ---@param highlights Highlights
    ---@param colors ColorScheme
    on_highlights = function(highlights, colors)
      highlights.LeapLabelPrimary = {
        bg = colors.bg_highlight,
        fg = colors.magenta2,
      }
      highlights.LeapLabelSecondary = {
        bg = colors.bg_highlight,
        fg = colors.fg,
      }
    end,
  })
  vim.cmd([[colorscheme tokyonight-day]])
  vim.cmd([[hi WinSeparator guifg=#7ea9e6]])
  vim.cmd([[hi NvimTreeWinSeparator guifg=#7ea9e6]])
end

return M
