return {
  {
    "augmentcode/augment.vim",
    -- Assurez-vous que le plugin est chargé dès le démarrage
    lazy = false,
    -- Configuration du plugin
    config = function()
      -- Définir vos dossiers de travail
      vim.g.augment_workspace_folders = {
        -- "/home/mickmart/projet/fdf/",
        -- "/home/mickmart/projet",
        --"/home/mickmart/projet/philo/philo/",
        "/home/mickmart/projet/inshell/",
        "/home/mickmart/projet/philo/",
      }

      -- Configurez d'autres options selon vos besoins
      -- vim.g.augment_disable_tab_mapping = true -- Décommentez si vous voulez désactiver le mapping de Tab

      -- Créez des mappings personnalisés
      vim.keymap.set("n", "<leader>ac", ":Augment chat<CR>", { desc = "Augment Chat" })
      vim.keymap.set("v", "<leader>ac", ":Augment chat<CR>", { desc = "Augment Chat Selection" })
      vim.keymap.set("n", "<leader>an", ":Augment chat-new<CR>", { desc = "Augment New Chat" })
      vim.keymap.set("n", "<leader>at", ":Augment chat-toggle<CR>", { desc = "Augment Toggle Chat" })
    end,
  },
}
