local M = {}
M.setup = function()
  -- Globally override LSP floating window.
  require("lspconfig.ui.windows").default_options.border = "single"

  -- Disable some annoying lsp ui.
  -- Note that ts-autotag plugin also modifies diagnostic settings for sepcial reasons.
  -- See: nvim-ts-autotag-config.lua for details
  vim.diagnostic.config({
    virtual_text = {
      severity = vim.diagnostic.severity.ERROR,
      current_line = true,
    },
    underline = {
      severity = { min = vim.diagnostic.severity.ERROR },
    },
  })

  local num_index_cpu = math.min(math.floor(#vim.loop.cpu_info() / 2), 16)

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  local keymap = require("keymap")

  -- local navic = require("nvim-navic")

  local function on_attach_base(client, buf)
    keymap.lsp_set_map(client, bufnr)
    -- if client.server_capabilities.documentSymbolProvider then
    --   navic.attach(client, bufnr)
    -- end
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true)
    end

  end
  local lsp_servers = {
    lua_ls = {
      on_attach = on_attach_base,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    },
    clangd = {
      on_attach = on_attach_base,
      capabilities = capabilities,
      cmd = {
        "clangd",
        "--all-scopes-completion",
        "--background-index",
        "-j=" .. num_index_cpu,
        "--clang-tidy",
        "--completion-style=bundled",
        -- Sometimes symbols are defined in internal-only headers.
        -- And you should include some interface headers instead.
        -- Clangd won't recognise it.
        -- `iwyu` config may insert interface headers.
        "--header-insertion=never",
        "--pretty",
        "--pch-storage=memory",
        "--header-insertion-decorators",
        "--function-arg-placeholders",
        "--fallback-style=Google",
        "--enable-config",
      },
    },
    pyright = {
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
    },
    basedpyright = {
      on_attach = on_attach_base,
      capabilities = capabilities,
      settings = {
        basedpyright = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
            typeCheckingMode = "recommended",
            diagnosticSeverityOverrides = {
              reportMissingParameterType = "information",
              reportAny = "hint",
              reportPossiblyUnboundVariable = "information",
              reportAttributeAccessIssue = "information",
              reportGeneralTypeIssues = "hint",
              reportOptionalMemberAccess = "hint",
              reportReturnType = "warning",
              reportMissingTypeArgument = "information",
              reportUnusedImport = "information",
              reportUnusedCallResult = "hint",
              reportUnknownVariableType = "hint",
              reportAssignmentType = "information",
              reportDeprecated = "information",
              reportUnannotatedClassAttribute = false,
              reportUnknownMemberType = "hint",
              reportArgumentType = "hint",
              reportUnknownArgumentType = "hint",
              reportUnknownParameterType = "hint",
              reportImplicitOverride = false,
              reportIncompatibleMethodOverride = "warning",
            },
          },
        },
      },
    },
    yamlls = {
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        on_attach_base(client, bufnr)
      end,
      capabilities = capabilities,
      settings = {
        editor = {
          tabSize = 2,
        },
        yaml = {
          format = {
            enable = true,
          },
          schemaStore = {
            enable = true,
          },
        },
      },
    },
  }

  for name, cfg in pairs(lsp_servers) do
    vim.lsp.enable(name)
    vim.lsp.config(name, cfg)
  end
end
return M
