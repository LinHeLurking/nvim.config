vim.g.mapleader = " "

local keymap = {}

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
auto_bind("<C-s>", "<Cmd>:w<CR>", opts)
auto_bind("<S-Tab>", "<Cmd>:< <CR>", opts)
vim.keymap.set("i", "<C-h>", "<Esc>^<Insert>", opts)
vim.keymap.set("i", "<C-l>", "<Esc>$a", opts)

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

-- Don't know why <A-F12> is <F60> :P
keymap.term_toggle_key = function()
  return "<F60>"
end

keymap.set_term_keymap = function()
  local opts = { silent = true, noremap = true, buffer = 0 }
  vim.keymap.set("t", "<Esc>", keymap.term_toggle_key() .. "<C-n>", opts)
  vim.keymap.set("t", "<A-h>", "<Cmd>wincmd h<CR>", opts)
  vim.keymap.set("t", "<A-j>", "<Cmd>wincmd j<CR>", opts)
  vim.keymap.set("t", "<A-k>", "<Cmd>wincmd k<CR>", opts)
  vim.keymap.set("t", "<A-l>", "<Cmd>wincmd l<CR>", opts)
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
-- LSP
--

local async_format = function()
  vim.lsp.buf.format({ async = true })
end

keymap.lsp_set_map = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  wk.register({
    d = { vim.lsp.buf.definition, "Definition" },
    D = { vim.lsp.buf.declaration, "Declaration" },
    i = { vim.lsp.buf.implementation, "Implementation" },
    t = { vim.lsp.buf.type_definition, "Type Definition" },
  }, { prefix = "g", buffer = bufnr })
  -- Refactor related mappings
  wk.register({
    name = "Refactor",
    r = { vim.lsp.buf.rename, "Rename" },
    f = { async_format, "Format" },
    a = { vim.lsp.buf.code_action, "Code Action" },
  }, { prefix = "<Leader>r", buffer = bufnr })
end

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
      return cmp.scroll_docs(5)
    else
      callback()
    end
  end)
  local smart_scroll_down = cmp.mapping(function(callback)
    if cmp.visible() then
      return cmp.scroll_docs(-5)
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
    ["<C-u>"] = smart_scroll_down,
    ["<C-d>"] = smart_scroll_up,
    ["<C-n>"] = smart_next,
    ["<C-j>"] = smart_next,
    ["<C-p>"] = smart_prev,
    ["<C-k>"] = smart_prev,
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
    name = "Telescope",
    f = { telescope.find_files, "Find Files" },
    g = { telescope.live_grep, "Live Grep" },
    b = { telescope.buffers, "Buffers" },
    h = { telescope.help_tags, "Help Tags" },
    r = { telescope.oldfiles, "Recent Files" },
    p = { show_prj, "Project" },
  }, { prefix = "<Leader>f" })
end

--
-- Intellij Flavor Keybindings
--
keymap.lsp_set_map_intellij = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  auto_bind("<C-A-l>", async_format, bufopts)
  auto_bind("<C-q>", vim.lsp.buf.signature_help, bufopts)
  -- <F18> is <S-F6> :P
  auto_bind("<F18>", vim.lsp.buf.rename, bufopts)
end
auto_bind("<A-1>", "<Cmd>NvimTreeToggle<CR>", opts) -- insert mode bind is buggy
auto_bind("<C-_>", "<Cmd>CommentToggle<CR>", opts)

return keymap
