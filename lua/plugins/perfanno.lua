-- plugins/perfanno.lua
return {
  "t-troebst/perfanno.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- Optionnel mais recommandé
  },
  event = "VeryLazy", -- charge PerfAnno quand c'est utile
  config = function()
    local perfanno = require("perfanno")
    local util = require("perfanno.util")

    perfanno.setup({
      -- Couleurs des lignes chaudes
      line_highlights = util.make_bg_highlights(nil, "#CC3300", 10),
      vt_highlight = util.make_fg_highlight("#CC3300"),

      -- Config formats (pourcentage ou valeurs brutes)
      formats = {
        { percent = true, format = "%.2f%%", minimum = 0.5 },
        { percent = false, format = "%d", minimum = 1 },
      },

      annotate_after_load = true,
      annotate_on_open = true,

      telescope = {
        enabled = pcall(require, "telescope"),
        annotate = true,
      },

      ts_function_patterns = {
        default = {
          "function",
          "method",
        },
      },
    })

    -- Keymaps
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Charger les données
    keymap("n", "<leader>plf", ":PerfLoadFlat<CR>", opts)
    keymap("n", "<leader>plg", ":PerfLoadCallGraph<CR>", opts)
    keymap("n", "<leader>plo", ":PerfLoadFlameGraph<CR>", opts)

    -- Événements
    keymap("n", "<leader>pe", ":PerfPickEvent<CR>", opts)

    -- Annoter
    keymap("n", "<leader>pa", ":PerfAnnotate<CR>", opts)
    keymap("n", "<leader>pf", ":PerfAnnotateFunction<CR>", opts)
    keymap("v", "<leader>pa", ":PerfAnnotateSelection<CR>", opts)

    keymap("n", "<leader>pt", ":PerfToggleAnnotations<CR>", opts)

    -- Trouver les lignes chaudes
    keymap("n", "<leader>ph", ":PerfHottestLines<CR>", opts)
    keymap("n", "<leader>ps", ":PerfHottestSymbols<CR>", opts)
    keymap("n", "<leader>pc", ":PerfHottestCallersFunction<CR>", opts)
    keymap("v", "<leader>pc", ":PerfHottestCallersSelection<CR>", opts)
  end,
}
