require("mason").setup({
  ui = {
    border = "single",
  },
})

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

require("mason-lspconfig").setup()

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    -- General spell check
    null_ls.builtins.diagnostics.codespell,
    -- Lua
    null_ls.builtins.formatting.stylua,
    -- Javascript/HTML/CSS
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.prettierd,
    -- Json
    null_ls.builtins.formatting.jq,
    null_ls.builtins.diagnostics.jsonlint,
    -- C/C++
    null_ls.builtins.formatting.clang_format,
    -- Python
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.diagnostics.pylint.with({
      extra_args = {
        -- Suppress docstring warning (C0111) :P
        --
        -- Suppress wildcard-import warnning (W0401)
        --
        -- Import checking is problematic for packages written in C. (E0401)
        -- Disable it. Don't worry, pyright checks it right :P
        --
        -- Suppress warning about `too many locals` (R0914)
        --
        -- Suppress `undefined-variable` because pylint wrongly report it for some imports. (E0602)
        -- Don't worry, pyright still handles it.
        "--disable=C0111,E0401,R0914,E0602,W0401",
        -- Suppress snake name check rules for 1 or 2 length names :P
        "--good-names-rgxs=^[_a-z][_a-z0-9]?$",
      },
    }),
  },
})
require("mason-null-ls").setup()

local navic = require("nvim-navic")
-- local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Globally override LSP floating window.
require("lspconfig.ui.windows").default_options.border = "single"

local on_attach = function(client, bufnr)
  local keymap = require("keymap")
  keymap.lsp_set_map(client, bufnr)
  keymap.lsp_set_map_intellij(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

require("mason-lspconfig").setup_handlers({
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup({
      on_attach = on_attach,
    })
  end,
  -- Next, you can provide targeted overrides for specific servers.
  -- For example, a handler override for the `rust_analyzer`:
  --["rust_analyzer"] = function ()
  --require("rust-tools").setup {}
  --end
  ["sumneko_lua"] = function()
    require("lspconfig").sumneko_lua.setup({
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })
  end,
  ["clangd"] = function()
    require("lspconfig").clangd.setup({
      on_attach = on_attach,
      cmd = {
        "clangd",
        "--all-scopes-completion",
        "--background-index",
        "--clang-tidy",
        -- "--compile-commands-dir=build",
        "--completion-style=bundled",
        "--header-insertion=iwyu",
        "--pretty",
        "--pch-storage=memory",
        "--header-insertion-decorators",
        "--function-arg-placeholders",
        "--fallback-style=Google",
      },
    })
  end,
  ["pyright"] = function()
    require("lspconfig").pyright.setup({
      on_attach = on_attach,
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "workspace",
            useLibraryCodeForTypes = true,
            -- Most of code types are missing. VSCode disables it by default :P
            typeCheckingMode = "off",
          },
        },
      },
    })
  end,
})
