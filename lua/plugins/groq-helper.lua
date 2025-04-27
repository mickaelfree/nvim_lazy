-- ~/.config/nvim/lua/plugins/groq-helper.lua
local function setup()
  local api = vim.api
  local curl = require("plenary.curl")

  -- Configuration avec prompts pédagogiques détaillés
  local config = {
    api_url = "https://api.groq.com/openai/v1/chat/completions",
    model = "mixtral-8x7b-32768",
    prompts = {
      -- Questions Socratiques Progressives
      socratic = [[En tant que mentor Socratique, pose une série de questions progressives pour comprendre ce concept :
1. D'abord, des questions de clarification basiques
2. Ensuite, des questions sur les hypothèses sous-jacentes
3. Puis, des questions sur les implications
4. Enfin, des questions de synthèse
Le concept est : ]],

      -- Décomposition Conceptuelle
      concept_map = [[Décompose ce concept en créant une carte mentale :
1. Concept central
2. Principes fondamentaux
3. Relations clés
4. Applications pratiques
5. Concepts connexes
Le concept à analyser est : ]],

      -- Analogies et Métaphores
      analogies = [[Explique ce concept à travers des analogies de la vie quotidienne.
Ne donne pas d'exemple technique, mais utilise des comparaisons avec :
1. Des situations quotidiennes
2. Des objets familiers
3. Des expériences communes
Le concept à expliquer est : ]],

      -- Progression d'Apprentissage
      learning_path = [[Crée un chemin d'apprentissage progressif pour ce concept :
1. Quels sont les prérequis essentiels ?
2. Quelles sont les étapes d'apprentissage ?
3. Quels sont les points de contrôle de compréhension ?
4. Comment vérifier la maîtrise ?
Le concept à apprendre est : ]],

      -- Debuggage Mental
      misconceptions = [[Identifie et corrige les confusions courantes :
1. Quelles sont les erreurs de compréhension typiques ?
2. Pourquoi ces erreurs sont-elles fréquentes ?
3. Comment éviter ces pièges ?
4. Quels sont les points clés à retenir ?
Le concept à clarifier est : ]],

      -- Principes Fondamentaux
      core_principles = [[Extrais les principes fondamentaux de ce concept :
1. Quels sont les axiomes de base ?
2. Quelles sont les règles invariables ?
3. Quels patterns se répètent ?
4. Quelles sont les exceptions importantes ?
Le concept à analyser est : ]],

      -- Contexte et Applications
      context = [[Replace ce concept dans son contexte plus large :
1. D'où vient ce concept ?
2. Pourquoi a-t-il été développé ?
3. Où est-il particulièrement utile ?
4. Comment s'intègre-t-il avec d'autres concepts ?
Le concept à contextualiser est : ]],

      -- Vision Expert
      expert_view = [[Comment un expert voit-il ce concept ?
1. Quelles subtilités un novice pourrait manquer ?
2. Quels aspects sont souvent mal compris ?
3. Quelles optimisations sont possibles ?
4. Quels cas limites sont importants ?
Le concept à analyser est : ]],

      -- Bonnes Pratiques
      best_practices = [[Explique les meilleures pratiques pour ce concept :
1. Conventions et standards :
   - Quelles sont les conventions établies ?
   - Quels standards suivre ?
   - Quelles sont les pratiques recommandées ?

2. Anti-patterns à éviter :
   - Quelles sont les erreurs communes ?
   - Quels pièges éviter ?
   - Quelles sont les mauvaises pratiques courantes ?

3. Cas d'utilisation :
   - Quand utiliser ce concept ?
   - Quand ne pas l'utiliser ?
   - Quelles sont les alternatives ?

4. Sécurité et robustesse :
   - Quels aspects de sécurité considérer ?
   - Comment rendre le code plus robuste ?
   - Quelles vérifications implémenter ?

5. Maintenabilité :
   - Comment rendre le code maintenable ?
   - Comment documenter efficacement ?
   - Comment faciliter les tests ?

Le concept à analyser est : ]],

      -- Optimisation
      optimization = [[Analyse les aspects d'optimisation pour ce concept :
1. Performance :
   - Quels sont les goulots d'étranglement typiques ?
   - Quelles optimisations sont possibles ?
   - Quels compromis considérer ?

2. Complexité :
   - Quelle est la complexité temporelle ?
   - Quelle est la complexité spatiale ?
   - Comment réduire la complexité ?

3. Ressources :
   - Comment optimiser l'utilisation mémoire ?
   - Comment améliorer l'efficacité CPU ?
   - Quelles ressources sont critiques ?

4. Scalabilité :
   - Comment le code se comporte à grande échelle ?
   - Quels problèmes peuvent survenir ?
   - Comment améliorer la scalabilité ?

5. Cas limites :
   - Quels cas limites considérer ?
   - Comment gérer les situations extrêmes ?
   - Quelles optimisations spécifiques appliquer ?

Le concept à optimiser est : ]],

      -- Style de Code
      code_style = [[Analyse le style de code pour ce concept :
1. Lisibilité :
   - Comment rendre le code plus lisible ?
   - Quelles conventions de nommage utiliser ?
   - Comment structurer le code ?

2. Modularité :
   - Comment découper le code ?
   - Quelle architecture adopter ?
   - Comment gérer les dépendances ?

3. Design Patterns :
   - Quels patterns sont applicables ?
   - Comment les implémenter correctement ?
   - Quels bénéfices apportent-ils ?

4. Tests :
   - Comment tester efficacement ?
   - Quels cas de test prévoir ?
   - Comment assurer la couverture ?

5. Documentation :
   - Comment documenter le code ?
   - Quels aspects documenter ?
   - Comment maintenir la documentation ?

Le concept à analyser est : ]],
      -- Analyse Pareto (20/80)
      pareto = [[Analyse selon le principe de Pareto (20/80) pour ce concept :
1. Points critiques (20%) :
   - Quels sont les éléments essentiels ?
   - Quelles parties demandent le plus d'attention ?
   - Où faut-il concentrer ses efforts ?

2. Impact maximal (80%) :
   - Quelles optimisations auront le plus d'impact ?
   - Quelles parties du code sont les plus utilisées ?
   - Où sont les gains rapides possibles ?

3. Priorités d'apprentissage :
   - Quels concepts maîtriser en premier ?
   - Quelles compétences développer prioritairement ?
   - Quels patterns sont les plus importants ?

Le concept à analyser est : ]],

      -- Quick Debug
      quick_debug = [[Pour un debugging efficace de ce concept :
1. Points de contrôle clés :
   - Où placer les breakpoints stratégiques ?
   - Quelles variables surveiller ?
   - Quels cas tester en priorité ?

2. Erreurs courantes (80%) :
   - Quels problèmes causent la majorité des bugs ?
   - Quelles vérifications faire en premier ?
   - Quels patterns d'erreurs rechercher ?

3. Solutions rapides :
   - Quelles corrections apportent les meilleurs résultats ?
   - Quelles optimisations sont les plus simples ?
   - Quels tests effectuer en priorité ?

Le problème à debugger est : ]],

      -- Quick Optimize
      quick_optimize = [[Pour une optimisation efficace selon le principe 20/80 :
1. Goulots d'étranglement :
   - Où sont les 20% du code qui causent 80% des problèmes ?
   - Quelles optimisations donneront les meilleurs résultats ?
   - Quels compromis sont les plus rentables ?

2. Gains rapides :
   - Quelles optimisations sont faciles à implémenter ?
   - Quelles parties du code sont les plus critiques ?
   - Où sont les victoires rapides ?

3. Validation :
   - Comment mesurer l'impact des optimisations ?
   - Quels benchmarks utiliser ?
   - Comment valider les améliorations ?

Le code à optimiser est : ]],

      -- Quick Review
      quick_review = [[Pour une revue de code efficace (20% qui compte pour 80%) :
1. Points critiques :
   - Quels aspects vérifier en priorité ?
   - Quels patterns problématiques rechercher ?
   - Quelles bonnes pratiques sont essentielles ?

2. Sécurité et robustesse :
   - Quelles sont les vulnérabilités courantes ?
   - Quels cas limites vérifier ?
   - Quelles validations sont critiques ?

3. Maintenabilité :
   - Quels aspects du code pourraient poser problème ?
   - Comment améliorer la lisibilité ?
   - Quelles parties nécessitent une refactorisation ?

Le code à revoir est : ]],
      -- Ajouter ces prompts dans la section config.prompts :

      -- Style John Carmack
      carmack_style = [[Analyse ce problème avec l'approche John Carmack :
1. Optimisation bas niveau :
   - Comment optimiser au niveau des registres ?
   - Quelles optimisations bit-à-bit sont possibles ?
   - Comment minimiser les accès mémoire ?

2. Architecture performante :
   - Comment structurer pour la performance ?
   - Quelles structures de données utiliser ?
   - Comment gérer la mémoire efficacement ?

3. Approche pragmatique :
   - Quelle est la solution la plus directe ?
   - Comment simplifier la logique ?
   - Quels compromis performance/lisibilité ?

4. Considérations techniques :
   - Comment exploiter le hardware ?
   - Quelles spécificités du CPU utiliser ?
   - Quelles optimisations assembleur possibles ?

Le problème à résoudre est : ]],

      -- Approche Full Pointeurs
      pointer_magic = [[Résous ce problème en utilisant uniquement des pointeurs :
1. Manipulation de pointeurs :
   - Comment utiliser l'arithmétique des pointeurs ?
   - Quelles structures avec pointeurs créer ?
   - Comment optimiser les déréférencements ?

2. Techniques avancées :
   - Comment utiliser les pointeurs de fonction ?
   - Quelles structures chaînées implémenter ?
   - Comment gérer les pointeurs multiples ?

3. Optimisations :
   - Comment minimiser les copies ?
   - Comment optimiser les accès mémoire ?
   - Quelles astuces pointeurs utiliser ?

4. Sécurité et robustesse :
   - Comment vérifier les pointeurs ?
   - Comment éviter les fuites ?
   - Quelles validations implémenter ?

Le problème à implémenter est : ]],

      -- Opérations Binaires
      bit_manipulation = [[Résous ce problème avec des opérations binaires :
1. Opérations bit à bit :
   - Quels masques binaires utiliser ?
   - Quelles opérations bit à bit appliquer ?
   - Comment optimiser les manipulations ?

2. Techniques binaires :
   - Comment utiliser les shifts ?
   - Quelles opérations AND/OR/XOR ?
   - Comment optimiser les tests de bits ?

3. Optimisations bas niveau :
   - Comment réduire les opérations ?
   - Quelles astuces binaires utiliser ?
   - Comment exploiter les flags CPU ?

4. Cas particuliers :
   - Comment gérer les signes ?
   - Comment traiter les overflows ?
   - Quelles limites considérer ?

Le problème à résoudre est : ]],

      -- Style 5 Étoiles
      five_stars = [[Analyse ce problème comme un mainteneur 5 étoiles :
1. Approche élégante :
   - Quelle solution la plus élégante ?
   - Comment maximiser l'efficacité ?
   - Quelles astuces avancées utiliser ?

2. Optimisations expertes :
   - Quelles optimisations non évidentes ?
   - Comment réduire la complexité ?
   - Quelles techniques avancées employer ?

3. Style et qualité :
   - Comment rendre le code parfait ?
   - Quelles conventions respecter ?
   - Comment dépasser les attentes ?

4. Documentation et clarté :
   - Comment documenter clairement ?
   - Quels aspects expliquer ?
   - Comment justifier les choix ?

Le problème à résoudre est : ]],

      -- Solutions Alternatives
      alternative_approaches = [[Propose différentes approches pour ce problème :
1. Solution classique :
   - Implémentation standard
   - Avantages/inconvénients
   - Cas d'utilisation

2. Solution orientée performance :
   - Optimisations possibles
   - Compromis nécessaires
   - Gains attendus

3. Solution orientée mémoire :
   - Gestion mémoire optimisée
   - Structures de données
   - Compromis espace/temps

4. Solution bit à bit :
   - Manipulations binaires
   - Optimisations bas niveau
   - Cas d'application

Le problème à analyser est : ]],
    },
  }

  -- Fonction pour récupérer la sélection visuelle
  local function get_visual_selection()
    -- Sauvegarde le registre original
    local a_orig = vim.fn.getreg("a")

    -- Vérifie le mode
    local mode = vim.fn.mode()
    if mode ~= "v" and mode ~= "V" then
      return ""
    end

    -- Copie la sélection dans le registre 'a'
    vim.cmd('noau normal! "ay')
    local text = vim.fn.getreg("a")

    -- Restaure le registre original
    vim.fn.setreg("a", a_orig)
    return text
  end

  -- Fonction pour créer une fenêtre flottante
  local function show_response(content)
    -- Crée un nouveau buffer
    local buf = api.nvim_create_buf(false, true)

    -- Calcule les dimensions
    local width = math.min(120, vim.o.columns - 4)
    local height = math.min(30, vim.o.lines - 4)

    -- Ouvre une fenêtre flottante
    local win = api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = 2,
      col = 2,
      style = "minimal",
      border = "rounded",
    })

    -- Configuration du buffer
    api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n"))
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")

    -- Raccourcis pour fermer
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
    vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = buf, silent = true })

    -- Active la coloration markdown
    vim.cmd("set ft=markdown")
  end

  -- Fonction pour interroger l'API Groq
  local function query_groq(prompt, text)
    local api_key = vim.env.GROQ_API_KEY
    if not api_key then
      vim.notify("GROQ_API_KEY manquante dans les variables d'environnement", "error")
      return
    end

    vim.notify("Réflexion en cours...", "info")

    local response = curl.post(config.api_url, {
      headers = {
        ["Authorization"] = "Bearer " .. api_key,
        ["Content-Type"] = "application/json",
      },
      body = vim.fn.json_encode({
        model = config.model,
        messages = {
          {
            role = "system",
            content = "Tu es john carmack mon mentor qui fournit toujours des exemples de code concrets et fonctionnels. Utilise des blocs de code avec la syntaxe ``` pour tous les exemples. Explique brièvement mais concentre-toi sur le code.",
          },
          {
            role = "user",
            content = prompt .. text,
          },
        },
      }),
    })

    if response.status == 200 then
      local result = vim.fn.json_decode(response.body)
      show_response(result.choices[1].message.content)
    else
      vim.notify("Erreur API Groq: " .. vim.inspect(response), "error")
    end
  end

  -- Fonction principale pour le menu
  local function ask_groq()
    local text = get_visual_selection()
    if text == "" then
      vim.notify("Aucune sélection de texte", "error")
      return
    end

    local choices = {
      { "⚡ Optimisation", config.prompts.optimization, "Performance et efficacité" },
      { "✨ Bonnes Pratiques", config.prompts.best_practices, "Standards et conventions" },
      { "📝 Style de Code", config.prompts.code_style, "Lisibilité et maintenance" },
      { "🤔 Questions Socratiques", config.prompts.socratic, "Comprendre par le questionnement" },
      { "🗺️  Carte Conceptuelle", config.prompts.concept_map, "Visualiser les relations" },
      { "🏠 Analogies Quotidiennes", config.prompts.analogies, "Comprendre par comparaison" },
      { "📈 Chemin d'Apprentissage", config.prompts.learning_path, "Progression structurée" },
      { "🐛 Correction Misconceptions", config.prompts.misconceptions, "Éviter les erreurs courantes" },
      { "🎯 Principes Fondamentaux", config.prompts.core_principles, "Bases essentielles" },
      { "🌍 Contexte et Applications", config.prompts.context, "Vue d'ensemble" },
      { "👨‍🔬 Vision Expert", config.prompts.expert_view, "Perspective avancée" },
      { "⚖️ 20/80 Analyse", config.prompts.pareto, "Points critiques et impact maximal" },
      { "🔍 Debug Rapide", config.prompts.quick_debug, "Debugging efficace" },
      { "⚡ Optimisation Rapide", config.prompts.quick_optimize, "Gains rapides" },
      { "👀 Revue Rapide", config.prompts.quick_review, "Revue de code efficace" },
      { "🚀 Style Carmack", config.prompts.carmack_style, "Approche John Carmack" },
      { "🔍 Full Pointeurs", config.prompts.pointer_magic, "Solution pointeurs" },
      { "⚡ Opérations Binaires", config.prompts.bit_manipulation, "Manipulation bits" },
      { "⭐ Style 5 Étoiles", config.prompts.five_stars, "Solution élégante" },
      { "🔄 Approches Alternatives", config.prompts.alternative_approaches, "Différentes solutions" },
    }

    vim.ui.select(choices, {
      prompt = "Comment voulez-vous explorer ce concept ?",
      format_item = function(item)
        return string.format("%s - %s", item[1], item[3])
      end,
    }, function(choice)
      if choice then
        query_groq(choice[2], text)
      end
    end)
  end

  -- Création de la commande et du mapping
  api.nvim_create_user_command("AskGroq", ask_groq, {})
  vim.keymap.set("v", "<leader>gh", "<cmd>AskGroq<CR>", {
    silent = true,
    desc = "Demander aide Groq",
  })

  -- Exposition des modules pour le cyberdeck
  return {
    config = config,
    query_groq = query_groq,
    ask_groq = ask_groq,
  }
end

-- Configuration du plugin avec exposition des modules
local M = {
  {
    dir = vim.fn.stdpath("config") .. "/lua/plugins",
    name = "groq-helper",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      return setup()
    end,
  },
}

-- Exécute et retourne le module pour l'accès externe
return M

