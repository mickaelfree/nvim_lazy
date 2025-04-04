-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("lspconfig").clangd.setup({
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
  end,
})
vim.opt.tabstop = 8 -- Largeur visuelle des tabulations
vim.opt.shiftwidth = 8 -- Nombre d'espaces pour l'indentation
vim.opt.expandtab = true --
