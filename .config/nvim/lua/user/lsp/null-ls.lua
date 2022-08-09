local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- augroup and on_attached used below are for format on save

null_ls.setup({
  debug = false,
  sources = {
    formatting.prettier.with({ extra_args = { "--trailing-comma", "none", "--config-precedence", "file-override" } }),
    formatting.black.with({ extra_args = { "--fast" } }),
    formatting.stylua,
    -- diagnostics.flake8
  },
})
