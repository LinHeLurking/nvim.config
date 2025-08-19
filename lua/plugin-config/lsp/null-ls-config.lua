local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end

  local null_ls = require("null-ls")

  local eslint_cond = function(utils)
    return utils.root_has_file({
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".rslintrs.yaml",
      ".eslintrc.yml",
      ".eslintrc.json",
    })
  end

  local prettier_cond = function(utils)
    return utils.root_has_file({
      ".prettierrc",
      ".prettierrc.json",
      ".prettierrc.yml",
      ".prettierrc.yaml",
      ".prettierrc.json5",
      ".prettierrc.js",
      ".prettierrc.config.js",
      ".prettierrc.mjs",
      ".prettierrc.cjs",
      ".prettierrc.config.cjs",
      ".prettierrc.toml",
    })
  end

  local setup_sources = function()
    local ideal_sources = {}
    -- General spell check
    if vim.fn.executable("codespell") == 1 then
    -- if 1 == 1 then
      local entry = null_ls.builtins.diagnostics.codespell.with({
        extra_args = {
          -- Suppress warnings for some words
          "-L ans,crate,crates",
        },
      })
      table.insert(ideal_sources, entry)
    end
    -- JS/TS/HTML/CSS
    for i, category in ipairs({ "diagnostics", "formatting", "code_actions" }) do
      local capability = null_ls.builtins[category]
      -- eslint_d is supported by extra tools
      if vim.fn.executable("eslint_d") == 1 then
      -- if 1 == 1 then
        local entry = require("none-ls." .. category .. ".eslint_d").with({
          condition = eslint_cond,
        })
        table.insert(ideal_sources, entry)
      end
    end
    for i, category in ipairs({ "formatting" }) do
      local capability = null_ls.builtins[category]
      -- if vim.fn.executable("prettierd") == 1 then
      if 1 == 1 then
        local entry = capability.prettierd.with({
          condition = prettier_cond,
        })
        table.insert(ideal_sources, entry)
      end
    end

    -- Json format
    if vim.fn.executable("jq") == 1 then
    -- if 1 == 1 then
      -- jq is supported by extra tools
      local entry = require("none-ls.formatting.jq")
      table.insert(ideal_sources, entry)
    end
    -- Lua format
    -- if vim.fn.executable("stylua") == 1 then
    if 1 == 1 then
      local entry = null_ls.builtins.formatting.stylua
      table.insert(ideal_sources, entry)
    end
    -- C/C++ format
    if vim.fn.executable("clang_format") == 1 then
    -- if 1 == 1 then
      local entry = null_ls.builtins.formatting.clang_format
      table.insert(ideal_sources, entry)
    end
    -- Python format
    if vim.fn.executable("black") == 1 then
    -- if 1 == 1 then
      local entry = null_ls.builtins.formatting.black
      table.insert(ideal_sources, entry)
    end
    return ideal_sources
  end

  null_ls.setup({
    sources = setup_sources(),
    border = "single",
    temp_dir = "/tmp"
  })
end

return M
