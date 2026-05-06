local M = {}
M.setup = function()
  -- Globally override LSP floating window.
  require("lspconfig.ui.windows").default_options.border = "single"

  -- Disable some annoying lsp ui.
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

  local keymap = require("keymap")
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      keymap.lsp_set_map(ev.buf)
    end
  })

  local lsp_servers = {
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    },
    clangd = {
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
      settings = {
        basedpyright = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
            typeCheckingMode = "off",
          },
        },
      },
    },
  }

  for name, cfg in pairs(lsp_servers) do
    vim.lsp.config(name, cfg)
  end
end
return M
