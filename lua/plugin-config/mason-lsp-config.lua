local keymap = require("keymap")

local navic = require("nvim-navic")

local on_attach_base = function(client, bufnr)
  keymap.lsp_set_map(client, bufnr)
  keymap.lsp_set_map_intellij(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

local lsp_config = require("lspconfig")
local dap_config = require("plugin-config/dap-config")
local rust_tools = require("rust-tools")

require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers({
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name)   -- default handler (optional)
    lsp_config[server_name].setup({
      on_attach = on_attach_base,
    })
  end,
  -- Next, you can provide targeted overrides for specific servers.
  -- For example, a handler override for the `rust_analyzer`:
  ["rust_analyzer"] = function()
    require("rust-tools").setup({
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
      dap = {
        adapter = {
          type = "executable",
          -- Use dap-config detected full-versioned lldb-vscode
          command = dap_config.lldb_vscode,
          name = "rust-tools-lldb",
        },
      },
    })
  end,
  ["lua_ls"] = function()
    lsp_config.lua_ls.setup({
      on_attach = on_attach_base,
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
    lsp_config.clangd.setup({
      on_attach = on_attach_base,
      cmd = {
        "clangd",
        "--all-scopes-completion",
        "--background-index",
        "--clang-tidy",
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
    lsp_config.pyright.setup({
      on_attach = on_attach_base,
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
