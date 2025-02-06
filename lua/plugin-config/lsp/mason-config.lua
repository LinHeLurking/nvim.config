local M = {}
M.setup = function()
  if vim.g.vscode ~= nil then
    return
  end

  local custom_bin = os.getenv("MASON_USE_CUSTOM_LSP_BIN") or ""
  custom_bin = string.upper(custom_bin)
  local mason_path_config = "prepend" -- this is default value
  if custom_bin == "1" or custom_bin == "ON" then
    mason_path_config = "append" -- this leads binaries from $PATH are selected over mason installed ones.
  end

  require("mason").setup({
    ui = {
      border = "single",
    },
    PATH = mason_path_config,
  })
end

return M
