require("mason").setup()
require("mason-lspconfig").setup()
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.codespell,
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.clang_format,
  },
})
require("mason-null-ls").setup()

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(client, bufnr)
  local keymap = require("keymap")
  keymap.lsp_set_map(client, bufnr)
  keymap.lsp_set_map_intellij(client, bufnr)
end

require("mason-lspconfig").setup_handlers({
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
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
      capabilities = capabilities,
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
      capabilities = capabilities,
      on_attach = on_attach,
      cmd = {
        "clangd",
        "--all-scopes-completion",
        "--background-index",
        "--clang-tidy",
        "--compile-commands-dir=build",
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
})
