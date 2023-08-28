local null_ls = require("null-ls")

local eslint_cond = function(utils)
  return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs", ".rslintrs.yaml", ".eslintrc.yml", ".eslintrc.json" })
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

null_ls.setup({
  sources = {
    -- General spell check
    null_ls.builtins.diagnostics.codespell.with({
      extra_args = {
        -- Suppress warnings for some words
        "-L ans,crate,crates",
      },
    }),
    -- Lua
    null_ls.builtins.formatting.stylua,
    -- Javascript/HTML/CSS
    null_ls.builtins.code_actions.eslint_d.with({
      condition = eslint_cond,
    }),
    null_ls.builtins.diagnostics.eslint_d.with({
      condition = eslint_cond,
    }),
    null_ls.builtins.formatting.eslint_d.with({
      condition = eslint_cond,
    }),
    null_ls.builtins.formatting.prettierd.with({
      condition = prettier_cond,
    }),
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
        -- Suppress warning about `to many arguments` (R0913)
        -- Suppress warning about `to few public methods` (R0903)
        --
        -- Suppress `undefined-variable` because pylint wrongly report it for some imports. (E0602)
        -- Don't worry, pyright still handles it.
        "--disable=C0111,E0401,R0914,E0602,W0401,R0913,R0903",
        -- Suppress snake name check rules for 1 or 2 length names :P
        "--good-names-rgxs=^[_a-z][_a-z0-9]?$",
      },
    }),
  },
  border = "single",
})
