local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end

  local cmp = require("cmp")
  local compare = require("cmp.config.compare")
  local types = require("cmp.types")

  local keymap = require("keymap").cmp_keys()

  local keyword_first = function(entry1, entry2)
    local kind1 = entry1:get_kind()
    local kind2 = entry2:get_kind()
    local e1_kwd = kind1 == cmp.lsp.CompletionItemKind.Keyword
    local e2_kwd = kind2 == cmp.lsp.CompletionItemKind.Keyword
    if e1_kwd and not e2_kwd then
      return true
    elseif not e1_kwd and e2_kwd then
      return false
    end
  end

  cmp.setup({
    enabled = function()
      local buf_filter = vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
      -- local dap_filter =require("cmp_dap").is_dap_buffer()
      local dap_filter = false
      return buf_filter or dap_filter
    end,
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    confirmation = { completeopt = "menu,menuone,noinsert" },
    mapping = cmp.mapping.preset.insert(keymap),
    sources = cmp.config.sources({
      { name = "nvim_lsp", priority = 1000 },
      { name = "luasnip",  priority = 750 }, -- For luasnip users.
      { name = "buffer",   priroity = 500 },
      { name = "path",     priority = 250 },
    }),
    sorting = {
      comparators = {
        keyword_first,
        compare.score,
        compare.offset,
        compare.exact,
        compare.recently_used,
        compare.locality,
        compare.kind,
        compare.sort_text,
        compare.length,
      },
    },
    view = {
      docs = {
        auto_open = true,
      },
    },
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
end
return M
