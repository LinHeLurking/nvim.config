local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end

  local keymap = require("keymap")

  local navic = require("nvim-navic")

  local on_attach_base = function(client, bufnr)
    keymap.lsp_set_map(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end

  -- local dap_config = require("plugin-config.dap-config")

  local num_index_cpu = math.min(math.floor(#vim.loop.cpu_info() / 2), 16)

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  require("mason-lspconfig").setup()
  require("mason-lspconfig").setup_handlers({
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
      require("lspconfig")[server_name].setup({
        on_attach = on_attach_base,
        capabilities = capabilities,
      })
    end,
    -- Next, you can provide targeted overrides for specific servers.
    -- For example, a handler override for the `rust_analyzer`:
    ["rust_analyzer"] = function()
      local rust_tools = require("rust-tools")
      rust_tools.setup({
        on_attach = on_attach_base,
        capabilities = capabilities,
        server = {
          on_attach = function(client, bufnr)
            on_attach_base(client, bufnr)

            -- Overwrite some keymaps
            -- Hover actions
            vim.keymap.set("n", "K", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set(
              "n",
              "<Leader>ra",
              rust_tools.code_action_group.code_action_group,
              { buffer = bufnr }
            )
          end,
        },
        tools = {
          inlay_hints = {
            auto = true,
          },
        },
      })
    end,
    ["lua_ls"] = function()
      require("lspconfig").lua_ls.setup({
        on_attach = on_attach_base,
        capabilities = capabilities,
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
        on_attach = on_attach_base,
        capabilities = capabilities,
        cmd = {
          "clangd",
          -- "--all-scopes-completion",
          "--background-index",
          "-j=" .. num_index_cpu,
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
          "--pretty",
          "--pch-storage=memory",
          "--header-insertion-decorators",
          "--function-arg-placeholders",
          "--fallback-style=Google",
          "--enable-config",
        },
      })
    end,
    ["pyright"] = function()
      require("lspconfig").pyright.setup({
        on_attach = on_attach_base,
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
              -- Most of code types are missing. VSCode disables it by default :P
              typeCheckingMode = "off",
            },
          },
        },
      })
    end,
  })
end

return M
