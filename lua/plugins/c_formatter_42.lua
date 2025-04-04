return {
  -- Plugin c_formatter_42
  {
    'cacharle/c_formatter_42.vim',
    ft = 'c',  -- Charge uniquement pour les fichiers C
    config = function()
      -- Configuration de base du formatteur
      vim.g.c_formatter_42_set_equalprg = 1  -- Utilise comme formatteur par défaut

      -- Mappings personnalisés
      vim.keymap.set('n', '<F2>', ':CFormatter42<CR>', {
        silent = true,
        buffer = true,
        desc = "Format C code (42 style)"
      })

      -- Fonction pour vérifier la norme avant sauvegarde
      local function check_norm_before_save()
        if vim.bo.filetype ~= 'c' then return end
        
        -- Sauvegarde la position du curseur
        local cursor_pos = vim.fn.getpos('.')
        
        -- Formate le code
        vim.cmd('CFormatter42')
        
        -- Lance norminette dans un split
        vim.cmd('Norminette')
        
        -- Restaure la position du curseur
        vim.fn.setpos('.', cursor_pos)
      end

      -- Auto-commandes pour gérer le formatage et la vérification
      local format_group = vim.api.nvim_create_augroup('CFormatter42Group', { clear = true })
      

      -- Ouvre le split de Norminette à droite
      vim.api.nvim_create_autocmd('BufWinEnter', {
        group = format_group,
        pattern = 'Norminette',
        callback = function()
          vim.cmd('wincmd L')  -- Déplace le split à droite
          vim.cmd('vertical resize 50')  -- Ajuste la largeur
        end
      })

      -- Configuration des couleurs pour Norminette
      vim.cmd([[
        highlight NorminetteError   guifg=#ff0000 ctermfg=red
        highlight NorminetteWarning guifg=#ffff00 ctermfg=yellow
        highlight NorminetteOK      guifg=#00ff00 ctermfg=green
        
        " Match les messages de Norminette
        syntax match NorminetteError   /Error:/
        syntax match NorminetteWarning /Warning:/
        syntax match NorminetteOK      /OK!/
      ]])

      -- Commandes utilitaires
      vim.api.nvim_create_user_command('FormatAndCheck', function()
        vim.cmd('CFormatter42')
        vim.cmd('Norminette')
      end, {
        desc = "Format code and check norm"
      })

      -- Mappings additionnels
      vim.keymap.set('n', '<leader>cf', ':FormatAndCheck<CR>', {
        silent = true,
        desc = "Format and check 42 norm"
      })
      
      vim.keymap.set('n', '<leader>cn', ':Norminette<CR>', {
        silent = true,
        desc = "Run Norminette check"
      })

      -- Menu contextuel pour les actions de formatage
      vim.keymap.set('n', '<leader>c', function()
        local actions = {
          { "Format (F2)", ':CFormatter42<CR>' },
          { "Check Norm", ':Norminette<CR>' },
          { "Format + Check", ':FormatAndCheck<CR>' },
        }
        
        vim.ui.select(actions, {
          prompt = "42 Format Actions:",
          format_item = function(item)
            return item[1]
          end,
        }, function(choice)
          if choice then
            vim.cmd(choice[2])
          end
        end)
      end, { desc = "42 Format Menu" })
    end
  }
}
