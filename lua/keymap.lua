local util = require("util")

vim.g.mapleader = " "

local keymap = {}

local async_format = util.async_format

local auto_bind = function(lhs, rhs, opt)
  if type(rhs) == "string" then
    vim.keymap.set("n", lhs, rhs, opt)
    local patch_rhs = "<Esc>" .. rhs .. "<Insert>"
    vim.keymap.set("i", lhs, patch_rhs, opt)
  elseif type(rhs) == "function" then
    vim.keymap.set("n", lhs, rhs, opt)
    vim.keymap.set("i", lhs, rhs, opt)
  end
end

--
-- Normal opts
--
local opts = { silent = true, noremap = true }

local wk = require("which-key")

local toggle_hls = function()
  if vim.api.nvim_get_option("hls") == true then
    vim.opt.hlsearch = false
  else
    vim.opt.hlsearch = true
  end
end

--
-- Misc
--
local smart_save = function()
  vim.cmd("w")
  -- Keep cursor not moving
  local pos = vim.api.nvim_win_get_cursor(0)
  if vim.fn.col("$") < pos[2] then
    pos[2] = pos[2] + 1
  end
  vim.api.nvim_win_set_cursor(0, pos)
end
auto_bind("<C-s>", smart_save, opts)
auto_bind("<S-Tab>", "<Cmd>< <CR>", opts)
auto_bind("<C-z>", "u", opts)
auto_bind("<C-a>", "ggVG", opts)
-- Don't know why it cannot bind :P
-- auto_bind("<C-S-z>", "<C-r>", opts)
vim.keymap.set("n", "<C-i>", "<C-a>", opts)
vim.keymap.set("v", "<C-c>", "y", opts)
vim.keymap.set("i", "<C-h>", "<Left>", opts)
vim.keymap.set("i", "<C-j>", "<Down>", opts)
vim.keymap.set("i", "<C-k>", "<Up>", opts)
vim.keymap.set("i", "<C-l>", "<Right>", opts)
-- vim.keymap.set("i", "<C-H>", "<Esc>^<Insert>", opts)
-- vim.keymap.set("i", "<C-L>", "<Esc>$a", opts)

--
-- Quick fix map
--
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    local qf_opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(0, "n", "q", "<Cmd>q<CR>", qf_opts)
  end,
})

--
-- Some common seetting toggle
--
wk.register({
  name = "Change Settings",
  h = { toggle_hls, "Toggle Highlight" },
  r = { "<Cmd>:set relativenumber!<CR>", "Toggle Relative Number" },
}, { prefix = "<Leader>c" })

--
-- Window action
--
wk.register({
  name = "Window Action",
  ["<A-h>"] = { "<C-w>h", "Move To Left Window" },
  ["<A-j>"] = { "<C-w>j", "Move To Down Window" },
  ["<A-k>"] = { "<C-w>k", "Move To Up Window" },
  ["<A-l>"] = { "<C-w>l", "Move To Right Window" },
}, {})

--
-- Terminal
--

wk.register({
  name = "Terminal",
  f = { "<Cmd>:ToggleTerm direction=float<CR>", "Open Float Terminal" },
  h = { "<Cmd>:ToggleTerm direction=horizontal<CR>", "Open Horizontal Terminal" },
  v = { "<Cmd>:ToggleTerm direction=vertical<CR>", "Open Vertical Terminal" },
}, { prefix = "<Leader>t" })

-- Don't know why <A-F12> is <F60> in WSL :P
keymap.term_toggle_key = function()
  -- if util.is_in_wsl() then
  return "<F60>"
  -- else
  --   return "<A-F12>"
  -- end
end

keymap.set_term_keymap = function()
  local term_opts = { silent = true, noremap = true, buffer = 0 }
  vim.keymap.set("t", "<Esc>", keymap.term_toggle_key() .. "<C-n>", term_opts)
  vim.keymap.set("t", "<A-h>", "<Cmd>wincmd h<CR>", term_opts)
  vim.keymap.set("t", "<A-j>", "<Cmd>wincmd j<CR>", term_opts)
  vim.keymap.set("t", "<A-k>", "<Cmd>wincmd k<CR>", term_opts)
  vim.keymap.set("t", "<A-l>", "<Cmd>wincmd l<CR>", term_opts)
end

--
-- Buffer Line Navigation
--
wk.register({
  name = "Buffer Action",
  l = { "<Cmd>BufferLineCycleNext<CR>", "Next Buffer" },
  h = { "<Cmd>BufferLineCyclePrev<CR>", "Previous Buffer" },
  p = { "<Cmd>BufferLinePick<CR>", "Pick Buffer" },
  c = {
    name = "Close Buffer",
    l = { "<Cmd>BufferLineCloseLeft<CR>", "Close Left Buffer" },
    r = { "<Cmd>BufferLineCloseRight<CR>", "Close Left Buffer" },
    p = { "<Cmd>BufferLinePickClose<CR>", "Close Left Buffer" },
  },
}, { prefix = "<Leader>b" })

--
-- Buffer Line Navigation
--
wk.register({
  t = { "<Cmd>BufferLineCycleNext<CR>", "Next Buffer" },
  T = { "<Cmd>BufferLineCyclePrev<CR>", "Previous Buffer" },
}, { prefix = "g" })

--
-- LSP
--

keymap.lsp_set_map = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set(
    "n",
    "<Leader>k",
    vim.lsp.buf.signature_help,
    { noremap = true, silent = true, desc = "Signature Help" }
  )
  auto_bind("<A-x>", function()
    require("lsp_signature").toggle_float_win()
  end, { noremap = true, silent = true, desc = "Toggle Signature Window" })
  wk.register({
    d = { vim.lsp.buf.definition, "Definition" },
    D = { vim.lsp.buf.declaration, "Declaration" },
    i = { vim.lsp.buf.implementation, "Implementation" },
    r = { vim.lsp.buf.references, "References" },
    -- t = { vim.lsp.buf.type_definition, "Type Definition" },
  }, { prefix = "g", buffer = bufnr })
  -- Refactor related mappings
  wk.register({
    name = "Refactor",
    r = { vim.lsp.buf.rename, "Rename" },
    f = { async_format, "Format" },
    a = { vim.lsp.buf.code_action, "Code Action" },
  }, { prefix = "<Leader>r", buffer = bufnr })
end
keymap.signature_help_select_next = "<A-n>"

--
-- DAP
--

-- These keys may not be convenient. Bind other keys in Intellij section.
local dap = require("dap")
wk.register({
  name = "DAP",
  b = { dap.toggle_breakpoint, "Toggle Break Point" },
  c = { dap.continue, "Continue" },
  o = { dap.step_over, "Step Over" },
  i = { dap.step_into, "Step Into" },
  q = { dap.terminate, "Stop" },
}, { prefix = "<Leader>d" })

--
-- CMake
--
wk.register({
  name = "CMake",
  g = { "<Cmd>CMakeGenerate<CR>", "Configure" },
  b = { "<Cmd>CMakeBuild<CR>", "Build" },
  c = { "<Cmd>CMakeClean<CR>", "Clean" },
  r = { "<Cmd>CMakeRun<CR>", "Run" },
  d = { "<Cmd>CMakeDebug<CR>", "Debug" },
  p = { "<Cmd>CMakeSelectConfigurePreset<CR>", "Configure Presets" },
}, { prefix = "<Leader>m" })

--
-- Trouble
--
keymap.trouble_keys = {
  action_keys = { -- key mappings for actions in the trouble list
    -- map to {} to remove a mapping, for example:
    -- close = {},
    close = "q", -- close the list
    cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
    refresh = "r", -- manually refresh
    jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
    open_split = { "<c-x>" }, -- open buffer in new split
    open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
    open_tab = { "<c-t>" }, -- open buffer in new tab
    jump_close = { "o" }, -- jump to the diagnostic and close the list
    toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
    toggle_preview = "P", -- toggle auto_preview
    hover = "K", -- opens a small popup with the full multiline message
    preview = "p", -- preview the diagnostic location
    close_folds = { "zM", "zm" }, -- close all folds
    open_folds = { "zR", "zr" }, -- open all folds
    toggle_fold = { "zA", "za" }, -- toggle fold of current file
    previous = "k", -- previous item
    next = "j", -- next item
  },
}
wk.register({
  name = "Trouble",
  x = { "<Cmd>TroubleToggle<CR>", "Toggle Trouble" },
  w = { "<Cmd>TroubleToggle workspace_diagnostics<CR>", "Workspace Diagnostics" },
  d = { "<Cmd>TroubleToggle document_diagnostics<CR>", "Document Diagnostics" },
  l = { "<Cmd>TroubleToggle loclist<CR>", "Location List" },
  q = { "<Cmd>TroubleToggle quickfix<CR>", "Quick Fix" },
}, { prefix = "<Leader>x" })

--
-- Auto Completion
--
keymap.cmp_keys = function()
  local cmp = require("cmp")
  local smart_esc = cmp.mapping(function(callback)
    if cmp.visible() then
      return cmp.abort()
    else
      callback()
    end
  end)
  local smart_cr = cmp.mapping(function(callback)
    if cmp.visible() then
      cmp.confirm()
    else
      callback()
    end
  end)
  local smart_scroll_up = cmp.mapping(function(callback)
    if cmp.visible() then
      return cmp.scroll_docs( -5)
    else
      callback()
    end
  end)
  local smart_scroll_down = cmp.mapping(function(callback)
    if cmp.visible() then
      return cmp.scroll_docs(5)
    else
      callback()
    end
  end)
  local smart_next = cmp.mapping(function(callback)
    if cmp.visible() then
      return cmp.select_next_item()
    else
      callback()
    end
  end)
  local smart_prev = cmp.mapping(function(callback)
    if cmp.visible() then
      return cmp.select_prev_item()
    else
      callback()
    end
  end)
  local keys = {
    ["<C-u>"] = smart_scroll_up,
    ["<C-d>"] = smart_scroll_down,
    ["<C-n>"] = smart_next,
    -- ["<C-j>"] = smart_next,
    ["<C-p>"] = smart_prev,
    -- ["<C-k>"] = smart_prev,
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = smart_cr,
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Esc>"] = smart_esc,
  }
  return keys
end

--
-- Telescope
--
keymap.telscope_set_map = function()
  local telescope = require("telescope.builtin")
  local project = require("telescope").extensions.project
  local show_prj = function()
    project.project({ display_type = "full" })
  end
  wk.register({
    name = "Find Everything",
    c = { telescope.commands, "Find Commands" },
    f = { telescope.find_files, "Find Files" },
    g = { telescope.live_grep, "Live Grep" },
    b = { telescope.buffers, "Buffers" },
    h = { telescope.help_tags, "Help Tags" },
    r = { telescope.oldfiles, "Recent Files" },
    p = { show_prj, "Project" },
  }, { prefix = "<Leader>f" })
end

--
-- Dashboard
--
keymap.dashboard_shortcut = {
  {
    desc = " Projects",
    key = "p",
    group = "Label",
    action = "Telescope project",
  },
  {
    desc = " Update",
    key = "u",
    group = "Label",
    action = "PackerUpdate",
  },
  {
    desc = " Settings",
    key = "s",
    group = "Label",
    action = "edit " .. util.get_config_dir(),
  },
  {
    desc = " Exit",
    key = "q",
    group = "Label",
    action = "exit",
  },
}

--
-- Hop
--
wk.register({
  name = "Hop Everywhere",
  w = { "<Cmd>:HopWord<CR>", "Hop Any Word" },
  c = { "<Cmd>:HopChar1<CR>", "Hop Any Character" },
  a = { "<Cmd>:HopAnywhere<CR>", "Hop Anywhere" },
}, { prefix = "<Leader>h" })

--
-- Intellij Flavor Keybindings
--
keymap.lsp_set_map_intellij = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  auto_bind("<C-A-l>", async_format, bufopts)
  -- This <C-q> breaks VISUAL-BLOCK key :P
  -- auto_bind("<C-q>", vim.lsp.buf.signature_help, bufopts)
  -- <F18> is <S-F6> in WSL :P
  -- if util.is_in_wsl() then
  auto_bind("<F18>", vim.lsp.buf.rename, bufopts)
  -- else
  -- auto_bind("<S-F6>", vim.lsp.buf.rename, bufopts)
  -- end
end
auto_bind("<A-1>", "<Cmd>NvimTreeToggle<CR>", opts) -- insert mode bind is buggy
auto_bind("<C-_>", "<Cmd>CommentToggle<CR>", opts)
vim.keymap.set("n", "<F9>", dap.continue, opts)
vim.keymap.set("n", "<F8>", dap.step_over, opts)
vim.keymap.set("n", "<F7>", dap.step_into, opts)
-- <F19> is <S-F7> in WSL
-- if util.is_in_wsl() then
vim.keymap.set("n", "<F19>", dap.step_out, opts)
-- else
--   vim.keymap.set("n", "<S-F7>", dap.step_out, opts)
-- end
-- <F14> is <C-F2> in WSL
-- if util.is_in_wsl() then
vim.keymap.set("n", "<F14>", dap.terminate, opts)
-- else
--   vim.keymap.set("n", "<S-F2>", dap.terminate, opts)
-- end

return keymap
