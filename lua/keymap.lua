local util = require("util")

vim.g.mapleader = " "

local not_vscode = vim.g.vscode == nil
local in_vscode = vim.g.vscode ~= nil
local vsc = {}
if not_vscode then
else
  vsc = require("vscode-neovim")
end

local keymap = {}

local async_format = util.async_format

local close_cur_buf = function()
  util.buffer_del_switch_focus(vim.api.nvim_get_current_buf())
end

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

--
-- Misc
--
if not_vscode then
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
  auto_bind("<C-z>", "u", opts)
end
auto_bind("<C-a>", "ggVG", opts)
vim.keymap.set("n", "<C-i>", "<C-a>", opts)
vim.keymap.set("i", "<C-h>", "<Left>", opts)
vim.keymap.set("i", "<C-j>", "<Down>", opts)
vim.keymap.set("i", "<C-k>", "<Up>", opts)
vim.keymap.set("i", "<C-l>", "<Right>", opts)
vim.keymap.set("i", "jj", "<Esc>", opts)
-- Delete indent for whole line
local delete_indent = function()
  local unpack = unpack or table.unpack
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if vim.bo.expandtab == true then
    -- indent with spaces
    local line = vim.api.nvim_get_current_line()
    if line:sub(1, col - 1) == string.rep(" ", col - 1) then
      -- <BS> automatically delete according to indent if it's in the front of line
      vim.api.nvim_input("<BS>")
    else
      local width = math.min(col - 1, vim.bo.shiftwidth)
      local segment = line:sub(col - width, col - 1)
      local cnt = 0
      for i = width, 1, -1 do
        if segment:sub(i, i) ~= " " then
          break
        end
        cnt = cnt + 1
      end
      if cnt == width then
        vim.api.nvim_input(string.rep("<BS>", width))
      else
        vim.cmd("<")
      end
    end
  else
    -- indent with tabs
    if col > 0 then
      vim.api.nvim_input("<BS>")
    end
  end
end
local smart_s_tab = function()
  if in_vscode then
    delete_indent()
  else
    local luasnip = require("luasnip")
    if luasnip.in_snippet() and luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      delete_indent()
    end
  end
end
vim.keymap.set({ "i", "v", "s" }, "<S-Tab>", smart_s_tab, opts)
-- Insert indent at cursor
local insert_indent = function()
  local indent = ""
  if vim.bo.expandtab == true then
    -- indent with spaces
    local width = vim.bo.shiftwidth
    indent = string.rep(" ", width)
  else
    -- indent with tabs
    indent = "\t"
  end
  vim.api.nvim_input(indent)
end
local smart_tab = function()
  if in_vscode then
    insert_indent()
  else
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    if cmp.visible() then
      local entry = cmp.get_selected_entry()
      if not entry then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      end
      cmp.confirm()
    elseif luasnip.in_snippet() and luasnip.jumpable(1) then
      luasnip.jump(1)
    else
      insert_indent()
    end
  end
end
vim.keymap.set({ "i", "v", "s" }, "<Tab>", smart_tab, opts)
-- Enable highlight when searching
vim.keymap.set("n", "/", "<Cmd>:set hlsearch<CR>/", { silent = false, noremap = true })
if not_vscode then
  vim.keymap.set("v", "<C-c>", "y", opts)
end

--
-- Leap
--
if not_vscode then
  wk.register({
    j = { "<Cmd>:HopWord<CR>", "Jump Anywhere" },
  }, { prefix = "<Leader>" })
end

--
-- Quick fix map
--

if not_vscode then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
      local qf_opts = { noremap = true, silent = true }
      vim.api.nvim_buf_set_keymap(0, "n", "q", "<Cmd>q<CR>", qf_opts)
    end,
  })
end

--
-- Some common seetting toggle
--
wk.register({
  name = "Change Settings",
  h = { "<Cmd>:set hlsearch!<CR>", "Toggle Highlight" },
  r = { "<Cmd>:set relativenumber!<CR>", "Toggle Relative Number" },
}, { prefix = "<Leader>c" })

--
-- Window action
--

if not_vscode then
  wk.register({
    name = "Window Action",
    ["<A-h>"] = { "<C-w>h", "Move To Left Window" },
    ["<A-j>"] = { "<C-w>j", "Move To Down Window" },
    ["<A-k>"] = { "<C-w>k", "Move To Up Window" },
    ["<A-l>"] = { "<C-w>l", "Move To Right Window" },
  }, {})
else
  local move = function(direction)
    return function()
      vsc.action("workbench.action.navigate" .. direction)
    end
  end
  wk.register({
    name = "Window Action",
    ["<A-h>"] = { move("Left"), "Move To Left Window" },
    ["<A-j>"] = { move("Down"), "Move To Down Window" },
    ["<A-k>"] = { move("Up"), "Move To Up Window" },
    ["<A-l>"] = { move("Right"), "Move To Right Window" },
  }, {})
end

--
-- Terminal
--

if not_vscode then
  wk.register({
    name = "Terminal",
    f = { "<Cmd>:ToggleTerm direction=float<CR>", "Open Float Terminal" },
    h = { "<Cmd>:ToggleTerm direction=horizontal<CR>", "Open Horizontal Terminal" },
    v = { "<Cmd>:ToggleTerm direction=vertical<CR>", "Open Vertical Terminal" },
  }, { prefix = "<Leader>t" })
end

-- Don't know why <A-F12> is <F60> in WSL/MacOS :P
keymap.term_toggle_key = function()
  if util.is_in_linux() or util.is_in_macos() then
    return "<F60>"
  else
    return "<A-F12>"
  end
end
vim.keymap.set("n", keymap.term_toggle_key(), "<Cmd>:ToggleTerm direction=float<CR>", opts)
vim.keymap.set("i", keymap.term_toggle_key(), "<Cmd>:ToggleTerm direction=float<CR>", opts)
vim.keymap.set("t", keymap.term_toggle_key(), "<Cmd>:ToggleTerm direction=float<CR>", opts)

keymap.set_term_keymap = function()
  local term_opts = { silent = true, noremap = true, buffer = 0 }
  vim.keymap.set("n", keymap.term_toggle_key(), "<Cmd>:ToggleTerm direction=float<CR>", opts)
  vim.keymap.set("t", keymap.term_toggle_key(), "<Cmd>:ToggleTerm direction=float<CR>", opts)
  vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", term_opts)
  vim.keymap.set("t", "<A-h>", "<Cmd>wincmd h<CR>", term_opts)
  vim.keymap.set("t", "<A-j>", "<Cmd>wincmd j<CR>", term_opts)
  vim.keymap.set("t", "<A-k>", "<Cmd>wincmd k<CR>", term_opts)
  vim.keymap.set("t", "<A-l>", "<Cmd>wincmd l<CR>", term_opts)
end

--
-- Git
--
if not_vscode then
  local gs = require("gitsigns")
  wk.register({
    name = "Git All in One",
    s = { gs.stage_hunk, "Stage Hunk" },
    r = { gs.reset_hunk, "Reset Hunk" },
    S = { gs.stage_buffer, "Stage Buffer" },
    u = { gs.undo_stage_hunk, "Undo Stage Hunk" },
    R = { gs.reset_buffer, "Reset Buffer" },
    D = { gs.toggle_deleted, "Toggle Deleted" },
    d = { gs.diffthis, "Diff This" },
  }, { prefix = "<Leader>g" })
  local get_v_lines = function()
    local l1 = vim.api.nvim_buf_get_mark(0, "<")[1]
    local l2 = vim.api.nvim_buf_get_mark(0, ">")[1]
    print(l1, l2)
    if l1 == nil or l2 == nil then
      return { nil, nil }
    end
    if l1 > l2 then
      l1, l2 = l2, l1
    end
    return { l1, l2 }
  end
  vim.keymap.set("v", "gs", function()
    local lines = get_v_lines()
    if lines[1] == nil then
      return
    end
    gs.stage_hunk(lines)
  end, { silent = true, noremap = true, desc = "Git stage visually setected lines" })
  vim.keymap.set("v", "gr", function()
    local lines = get_v_lines()
    if lines[1] == nil then
      return
    end
    gs.reset_hunk(lines)
  end, { silent = true, noremap = true, desc = "Git reset visually setected lines" })
  vim.keymap.set("n", "[c", function()
    vim.schedule(function()
      gs.prev_hunk()
    end)
  end, { silent = true, noremap = true, desc = "Previous git hunk" })
  vim.keymap.set("n", "]c", function()
    vim.schedule(function()
      gs.next_hunk()
    end)
  end, { silent = true, noremap = true, desc = "Next git hunk" })
end

--
-- Buffer Line Navigation
--

if not_vscode then
  wk.register({
    name = "Buffer Action",
    l = { "<Cmd>BufferLineCycleNext<CR>", "Next Buffer" },
    h = { "<Cmd>BufferLineCyclePrev<CR>", "Previous Buffer" },
    p = { "<Cmd>BufferLinePick<CR>", "Pick Buffer" },
    c = { close_cur_buf, "Close Buffer" },
  }, { prefix = "<Leader>b" })

  wk.register({
    t = { "<Cmd>BufferLineCycleNext<CR>", "Next Buffer" },
    T = { "<Cmd>BufferLineCyclePrev<CR>", "Previous Buffer" },
  }, { prefix = "g" })
end

--
-- LSP
--

if not_vscode then
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
    vim.keymap.set(
      "n",
      "<Leader>r",
      vim.lsp.buf.code_action,
      { noremap = true, silent = true, desc = "Refactor Actions", buffer = bufnr }
    )
  end
  keymap.signature_help_select_next = "<A-n>"
end

--
-- Trouble
--

if not_vscode then
  keymap.trouble_keys = {
    action_keys = {
      -- key mappings for actions in the trouble list
      -- map to {} to remove a mapping, for example:
      -- close = {},
      close = "q",               -- close the list
      cancel = "<esc>",          -- cancel the preview and get back to your last window / buffer / cursor
      refresh = "r",             -- manually refresh
      jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
      open_split = { "<c-x>" },  -- open buffer in new split
      open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
      open_tab = { "<c-t>" },    -- open buffer in new tab
      jump_close = { "o" },      -- jump to the diagnostic and close the list
      toggle_mode = "m",         -- toggle between "workspace" and "document" diagnostics mode
      toggle_preview = "P",      -- toggle auto_preview
      hover = "K",               -- opens a small popup with the full multiline message
      preview = "p",             -- preview the diagnostic location
      close_folds = { "zM", "zm" }, -- close all folds
      open_folds = { "zR", "zr" }, -- open all folds
      toggle_fold = { "zA", "za" }, -- toggle fold of current file
      previous = "k",            -- previous item
      next = "j",                -- next item
    },
  }
  wk.register({
    name = "Trouble",
    d = { "<Cmd>Trouble diagnostics toggle focus=true filter.buf=0<CR>", "Document Diagnostics" },
    q = { "<Cmd>Trouble quickfix toggle focus=true<CR>", "Quick Fix" },
  }, { prefix = "<Leader>x" })
end

--
-- Auto Completion
--

if not_vscode then
  keymap.cmp_keys = function()
    local cmp = require("cmp")
    local smart_esc = cmp.mapping(function(fallback)
      if cmp.visible() then
        return cmp.abort()
      else
        fallback()
      end
    end)
    local keys = {
      ["<C-u>"] = cmp.mapping.scroll_docs(-5),
      ["<C-d>"] = cmp.mapping.scroll_docs(5),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      -- It conflicts with tab mappings outside.
      -- ["<Tab>"] = smart_tab,
      ["<C-e>"] = cmp.mapping.abort(),
      ["<Esc>"] = smart_esc,
    }
    return keys
  end
end

--
-- Telescope
--

if not_vscode then
  wk.register({
    name = "Find Everything",
    c = { "<Cmd>Telescope commands<CR>", "Find Commands" },
    k = { "<Cmd>Telescope keymaps<CR>", "Find Keymaps" },
    f = { "<Cmd>Telescope find_files<CR>", "Find Files" },
    g = { "<Cmd>Telescope live_grep<CR>", "Live Grep" },
    b = { "<Cmd>Telescope buffers<CR>", "Buffers" },
    h = { "<Cmd>Telescope help_tags<CR>", "Help Tags" },
    r = { "<Cmd>Telescope oldfiles<CR>", "Recent Files" },
    s = { "<Cmd>Telescope lsp_document_symbols<CR>", "Document Symbols" },
  }, { prefix = "<Leader>f" })
else
  local find_files = function()
    vsc.action("workbench.action.quickOpen")
  end
  local find_in_files = function()
    vsc.action("workbench.action.findInFiles")
  end
  local shortcuts = function()
    vsc.action("workbench.action.openGlobalKeybindings")
  end
  local recent_files = function()
    vsc.action("workbench.action.openRecent")
  end
  local doc_symbol = function()
    vsc.action("workbench.action.gotoSymbol")
  end
  wk.register({
    name = "Find Everything",
    f = { find_files, "Find Files" },
    g = { find_in_files, "Live Grep" },
    c = { shortcuts, "Shortcuts" },
    r = { recent_files, "Recent Files" },
    s = { doc_symbol, "Document Symbols" },
  }, { prefix = "<Leader>f" })
end

--
-- Dashboard
--

if not_vscode then
  keymap.dashboard_shortcut = {
    {
      desc = "󰚰 Update",
      key = "u",
      group = "Label",
      action = "Lazy update",
    },
    {
      desc = " Settings",
      key = "s",
      group = "Label",
      action = "edit " .. util.get_config_dir(),
    },
    {
      desc = "󰗼 Exit",
      key = "q",
      group = "Label",
      action = "exit",
    },
  }
end

--
-- Intellij Flavor Keybindings
--

if not_vscode then
  auto_bind("<C-M-l>", async_format, opts)

  -- This <C-q> breaks VISUAL-BLOCK key :P
  -- auto_bind("<C-q>", vim.lsp.buf.signature_help, bufopts)
  -- <F18> is <S-F6> in Linux and MacOS :P
  if util.is_in_linux() or util.is_in_macos then
    auto_bind("<F18>", vim.lsp.buf.rename, opts)
  else
    auto_bind("<S-F6>", vim.lsp.buf.rename, opts)
  end
  auto_bind("<A-1>", "<Cmd>NvimTreeToggle<CR>", opts) -- insert mode bind is buggy
  auto_bind("<C-_>", "<Cmd>CommentToggle<CR>", opts)
  vim.keymap.set("v", "<C-_>", "<Cmd>'<,'>CommentToggle<CR>", opts)
end

return keymap
