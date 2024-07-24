local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end

  local cmp = require("cmp")
  local compare = require("cmp.config.compare")
  local types = require("cmp.types")

  local keymap = require("keymap").cmp_keys()

  local modified_kind_priority = {
    [types.lsp.CompletionItemKind.Keyword] = 0, -- top
    [types.lsp.CompletionItemKind.Snippet] = 0, -- top
    [types.lsp.CompletionItemKind.Text] = 100, -- bottom
  }

  local modified_kind = function(entry1, entry2)
    local kind1 = entry1:get_kind()
    local kind2 = entry2:get_kind()
    kind1 = modified_kind_priority[kind1] or kind1
    kind1 = modified_kind_priority[kind2] or kind2
    if kind1 ~= kind2 then
      return kind1 < kind2
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
      { name = "nvim_lsp" },
      -- { name = "vsnip" }, -- For vsnip users.
      { name = "luasnip" }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
      { name = "buffer" },
      { name = "path" },
    }),
    sorting = {
      comperators = {
        compare.offset,
        compare.exact,
        compare.score,
        compare.length,
        compare.recently_used,
        modified_kind,
        compare.scopes,
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
