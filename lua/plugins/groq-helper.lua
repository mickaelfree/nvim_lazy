-- ~/.config/nvim/lua/plugins/groq-helper.lua
return {
  "nvim-lua/plenary.nvim",
  lazy = false,
  config = function()
    local api = vim.api
    local curl = require("plenary.curl")

    -- Configuration avec prompts pédagogiques détaillés
    local config = {
      api_url = "https://api.groq.com/openai/v1/chat/completions",
      model = "llama-3.3-70b-versatile",
      prompts = {
        -- TECHNIQUES MNÉMONIQUES AVANCÉES --

        -- Chunking Mnémonique
        chunking = [[Décompose ce concept en chunks mnémoniques :
1. Identifie 5-7 unités d'information distinctes (chunks)
2. Organise ces chunks de manière hiérarchique
3. Crée des connections entre chunks utilisant des motifs ou associations
4. Suggère des phrases mnémoniques courtes pour chaque chunk
5. Propose une stratégie de révision espacée pour ces chunks

Le concept à chunker est : ]],

        -- Palais de Mémoire
        memory_palace = [[Crée un palais de mémoire pour ce concept de développement :
1. Définis 5-7 "pièces" distinctes représentant les aspects clés du concept
2. Pour chaque pièce, associe:
   - Une image vive et sensorielle
   - Un objet ou meuble distinct pour chaque sous-concept
   - Une action ou interaction mémorable
3. Crée un parcours logique reliant ces pièces
4. Ajoute des éléments insolites pour renforcer la mémorisation
5. Explique comment "parcourir" ce palais pour rappeler le concept

Le concept à mémoriser est : ]],

        -- Double Encodage
        dual_coding = [[Encode ce concept visuellement et verbalement :
1. Représentation textuelle concise (5-7 phrases clés)
2. Représentation visuelle (décrite en détail)
3. Connections explicites entre éléments visuels et textuels
4. Narration combinant les aspects visuels et verbaux
5. Suggestions pour renforcer l'encodage multisensoriel

Le concept à encoder est : ]],

        -- Interrogation Élaborative
        elaborative_interrogation = [[Pose les questions "pourquoi" essentielles :
1. Pourquoi ce concept fonctionne comme il le fait?
2. Pourquoi a-t-il été conçu de cette manière?
3. Pourquoi est-il structuré ainsi?
4. Pourquoi cette approche plutôt qu'une alternative?
5. Pourquoi est-il important de bien comprendre ce concept?
6. Pourquoi ce concept s'intègre-t-il avec d'autres de cette façon?
7. Fournir des réponses détaillées à chaque question

Le concept à interroger est : ]],

        -- Difficulté Désirable
        desirable_difficulty = [[Applique la technique de difficulté désirable à ce concept :
1. Version complexifiée délibérément :
   - Réécris le concept avec 30% plus de complexité
   - Introduis des abstractions supplémentaires
   - Ajoute des contraintes artificielles

2. Récupération forcée :
   - Crée 3-5 questions délibérément difficiles
   - Formule des problèmes qui semblent insolubles au premier abord
   - Propose des situations d'application avec informations manquantes

3. Résolution guidée :
   - Fournis des indices minimaux pour surmonter les obstacles
   - Décompose le chemin de résolution en étapes non-évidentes
   - Explique pourquoi cette difficulté renforce l'apprentissage

Le concept à apprendre par difficulté désirable est : ]],

        -- Explication Feynman Inversée
        inverted_feynman = [[Applique la technique Feynman inversée à ce concept :
1. Simplification extrême :
   - Explique d'abord ce concept comme à un enfant de 10 ans
   - Utilise uniquement des mots simples et des analogies concrètes
   - Évite tout jargon technique

2. Complexification progressive :
   - Réintroduis progressivement la complexité en 4 niveaux
   - À chaque niveau, identifie les lacunes de l'explication précédente
   - Marque explicitement les points où la simplicité devient trompeuse

3. Connexion finale :
   - Réconcilie la version simple et la version complexe
   - Crée un modèle mental hybride qui préserve l'intuition sans sacrifier la précision
   - Identifie les "ancres mentales" clés pour basculer entre niveaux de compréhension

Le concept à expliquer par méthode Feynman inversée est : ]],

        -- Interleaving Conceptuel
        interleaving = [[Applique la technique d'interleaving conceptuel à ce concept :
1. Identification des concepts connexes :
   - Identifie 3-4 concepts qui semblent non-reliés mais partagent des structures profondes
   - Trouve des domaines d'application radicalement différents
   - Sélectionne des concepts à différents niveaux d'abstraction

2. Tissage cognitif :
   - Alterne entre ces concepts par blocs de 3-5 phrases
   - Crée des transitions délibérément abruptes entre domaines
   - Force des connexions non-évidentes entre les concepts

3. Synthèse transversale :
   - Extrais les patterns communs qui émergent de ce tissage
   - Formule des principes métacognitifs applicables à tous les domaines
   - Crée une "carte de transfert" pour appliquer ce concept dans des contextes inattendus

Le concept principal pour l'interleaving est : ]],

        -- Récupération Temporisée Active
        timed_retrieval = [[Crée un protocole de récupération temporisée pour ce concept :
1. Points de rappel immédiats (après 1 minute) :
   - 3 questions courtes exigeant un rappel précis de détails clés
   - Force la récupération sans indices

2. Points de rappel à court terme (après 10 minutes) :
   - 2 problèmes d'application demandant une manipulation du concept
   - Fournir 30% des informations nécessaires

3. Points de rappel à moyen terme (après 1 jour) :
   - 1 problème de synthèse exigeant une reconstruction complète du concept
   - Ajouter une contrainte non présente dans l'apprentissage initial

4. Points de rappel à long terme (après 1 semaine) :
   - 1 problème d'intégration demandant de combiner ce concept avec un nouveau
   - Demander une application dans un domaine non couvert initialement

Le concept pour la récupération temporisée est : ]],

        -- Apprentissage Multi-Sensoriel Codé
        multisensory_coding = [[Encode ce concept dans multiples modalités sensorielles :
1. Encodage visuo-spatial :
   - Crée une représentation visuelle abstraite (décrite en détail)
   - Associe des couleurs spécifiques aux composantes clés
   - Définis des relations spatiales explicites entre éléments

2. Encodage auditif-rythmique :
   - Développe une phrase mnémonique avec un rythme spécifique
   - Crée des associations sonores pour les éléments clés
   - Propose un pattern de "lecture à voix haute" avec emphases

3. Encodage kinesthésique :
   - Conçois des gestes physiques représentant le concept
   - Crée une "chorégraphie cognitive" séquentielle
   - Décris les sensations physiques associées

4. Encodage émotionnel :
   - Associe des états émotionnels spécifiques à des aspects du concept
   - Crée une "histoire émotionnelle" suivant une progression
   - Établis des ancres émotionnelles pour les points critiques

Le concept à encoder multi-sensoriellement est : ]],

        -- ANALYSE DE PRINCIPES --

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

        -- Principes Fondamentaux
        core_principles = [[Extrais les principes fondamentaux de ce concept :
1. Quels sont les axiomes de base ?
2. Quelles sont les règles invariables ?
3. Quels patterns se répètent ?
4. Quelles sont les exceptions importantes ?
Le concept à analyser est : ]],

        -- Décomposition Conceptuelle
        concept_map = [[Décompose ce concept en créant une carte mentale :
1. Concept central
2. Principes fondamentaux
3. Relations clés
4. Applications pratiques
5. Concepts connexes
Le concept à analyser est : ]],

        -- MODÈLES MENTAUX --

        -- Méta-Modèle de Programmation
        meta_programming_model = [[Analyse ce concept avec ces modèles mentaux fondamentaux :
1. Modèle de flux de données:
   - Comment les données circulent-elles?
   - Quelles transformations subissent-elles?
   - Où sont les points de décision?

2. Modèle d'abstraction en couches:
   - Quelles sont les couches d'abstraction?
   - Comment interagissent-elles?
   - Quelles responsabilités à chaque niveau?

3. Modèle d'états et transitions:
   - Quels sont les états possibles?
   - Comment se produisent les transitions?
   - Quelles sont les invariants?

4. Modèle de composition/décomposition:
   - Comment ce concept peut-il être décomposé?
   - Comment peut-il être recombiné?
   - Quelles sont les unités minimales fonctionnelles?

Le concept à analyser est : ]],

        -- Modèles Mentaux en Débogage
        debugging_models = [[Applique ces modèles mentaux de débogage :
1. Modèle de cause à effet:
   - Quelles sont les relations causales?
   - Comment isoler les facteurs individuels?
   - Comment confirmer les hypothèses?

2. Modèle de regression:
   - Quand ce problème est-il apparu?
   - Quelles modifications ont pu l'introduire?
   - Comment revenir à un état fonctionnel?

3. Modèle de divide-and-conquer:
   - Comment bisectionner le problème?
   - Quelles parties peuvent être exclues?
   - Comment réduire l'espace de recherche?

4. Modèle d'anomalie systémique:
   - S'agit-il d'un problème isolé ou systémique?
   - Existe-t-il d'autres occurrences similaires?
   - Y a-t-il un pattern sous-jacent?

Le problème à déboguer est : ]],

        -- Modèles Mentaux d'Architecture
        architecture_models = [[Analyse cette architecture avec ces modèles mentaux :
1. Modèle de contraintes:
   - Quelles contraintes définissent le système?
   - Comment ces contraintes façonnent-elles les solutions?
   - Comment optimiser dans ces limites?

2. Modèle de couplage et cohésion:
   - Où sont les points de couplage?
   - Comment mesurer et améliorer la cohésion?
   - Quels changements amélioreraient la structure?

3. Modèle de surface d'attaque:
   - Quelles sont les vulnérabilités potentielles?
   - Comment réduire la surface d'attaque?
   - Quels mécanismes de défense en profondeur?

4. Modèle d'évolution:
   - Comment ce système évoluera-t-il?
   - Quelles parties changeront le plus?
   - Comment faciliter les changements futurs?

L'architecture à analyser est : ]],

        -- APPRENTISSAGE PROGRESSIF --

        -- Analogies et Métaphores
        analogies = [[Explique ce concept à travers des analogies de la vie quotidienne.
Ne donne pas d'exemple technique, mais utilise des comparaisons avec :
1. Des situations quotidiennes
2. Des objets familiers
3. Des expériences communes
Le concept à expliquer est : ]],

        -- Questions Socratiques Progressives
        socratic = [[En tant que mentor Socratique, pose une série de questions progressives pour comprendre ce concept :
1. D'abord, des questions de clarification basiques
2. Ensuite, des questions sur les hypothèses sous-jacentes
3. Puis, des questions sur les implications
4. Enfin, des questions de synthèse
Le concept est : ]],

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

        -- APPLICATIONS PRATIQUES --

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

        -- PERSPECTIVES AVANCÉES --

        -- Vision Expert
        expert_view = [[Comment un expert voit-il ce concept ?
1. Quelles subtilités un novice pourrait manquer ?
2. Quels aspects sont souvent mal compris ?
3. Quelles optimisations sont possibles ?
4. Quels cas limites sont importants ?
Le concept à analyser est : ]],

        -- Contexte et Applications
        context = [[Replace ce concept dans son contexte plus large :
1. D'où vient ce concept ?
2. Pourquoi a-t-il été développé ?
3. Où est-il particulièrement utile ?
4. Comment s'intègre-t-il avec d'autres concepts ?
Le concept à contextualiser est : ]],

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

        -- STYLES ET PRATIQUES --

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

        -- TECHNIQUES SPÉCIFIQUES --

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
      },

      -- Configuration pour la sauvegarde de concepts
      concepts_storage = {
        path = vim.fn.stdpath("data") .. "/groq_concepts.json",
        enabled = true,
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
        local content = result.choices[1].message.content
        show_response(content)
        return content
      else
        vim.notify("Erreur API Groq: " .. vim.inspect(response), "error")
        return nil
      end
    end

    -- Fonction pour sauvegarder un concept important
    local function save_concept(concept_name, content)
      if not config.concepts_storage.enabled then
        vim.notify("Stockage de concepts désactivé", "info")
        return
      end

      -- Charger les concepts existants ou créer une nouvelle structure
      local concepts = {}
      if vim.fn.filereadable(config.concepts_storage.path) == 1 then
        local content_file = vim.fn.readfile(config.concepts_storage.path)
        if #content_file > 0 then
          concepts = vim.fn.json_decode(table.concat(content_file, "\n"))
        end
      end

      -- Ajouter le nouveau concept avec horodatage
      table.insert(concepts, {
        name = concept_name,
        content = content,
        timestamp = os.time(),
        tags = {}, -- Pour une future catégorisation
        review_count = 0,
        next_review = os.time() + (24 * 60 * 60), -- Prochaine révision dans 24h
      })

      -- Sauvegarder le fichier mis à jour
      vim.fn.writefile({ vim.fn.json_encode(concepts) }, config.concepts_storage.path)
      vim.notify("Concept '" .. concept_name .. "' sauvegardé", "info")
    end

    -- Fonction pour afficher les concepts sauvegardés
    local function show_saved_concepts()
      if not config.concepts_storage.enabled then
        vim.notify("Stockage de concepts désactivé", "info")
        return
      end

      -- Vérifier si le fichier existe
      if vim.fn.filereadable(config.concepts_storage.path) ~= 1 then
        vim.notify("Aucun concept sauvegardé", "info")
        return
      end

      -- Charger les concepts
      local content = vim.fn.readfile(config.concepts_storage.path)
      if #content == 0 then
        vim.notify("Aucun concept sauvegardé", "info")
        return
      end

      local concepts = vim.fn.json_decode(table.concat(content, "\n"))

      -- Préparer l'affichage
      local display_text = "# Concepts Sauvegardés\n\n"
      for i, concept in ipairs(concepts) do
        local date_str = os.date("%Y-%m-%d %H:%M", concept.timestamp)
        local next_review_str = "Prochaine révision: "
          .. os.date("%Y-%m-%d", concept.next_review or (concept.timestamp + (24 * 60 * 60)))

        display_text = display_text .. "## " .. i .. ". " .. concept.name .. " (" .. date_str .. ")\n"
        display_text = display_text .. next_review_str .. "\n\n"
        display_text = display_text .. concept.content .. "\n\n"
        display_text = display_text .. "---\n\n"
      end

      -- Afficher dans une fenêtre flottante
      show_response(display_text)
    end

    -- Fonction pour vérifier les révisions dues
    local function check_due_reviews()
      if not config.concepts_storage.enabled then
        return
      end

      -- Vérifier si le fichier existe
      if vim.fn.filereadable(config.concepts_storage.path) ~= 1 then
        return
      end

      -- Charger les concepts
      local content = vim.fn.readfile(config.concepts_storage.path)
      if #content == 0 then
        return
      end

      local concepts = vim.fn.json_decode(table.concat(content, "\n"))

      -- Compter les révisions dues
      local now = os.time()
      local due_count = 0

      for _, concept in ipairs(concepts) do
        if concept.next_review and concept.next_review <= now then
          due_count = due_count + 1
        end
      end

      if due_count > 0 then
        vim.notify(due_count .. " concept(s) à réviser aujourd'hui. Utilisez <leader>sr pour réviser.", "info")
      end
    end

    -- Fonction pour réviser les concepts dus
    local function review_due_concepts()
      if not config.concepts_storage.enabled then
        vim.notify("Stockage de concepts désactivé", "info")
        return
      end

      -- Vérifier si le fichier existe
      if vim.fn.filereadable(config.concepts_storage.path) ~= 1 then
        vim.notify("Aucun concept à réviser", "info")
        return
      end

      -- Charger les concepts
      local content = vim.fn.readfile(config.concepts_storage.path)
      if #content == 0 then
        vim.notify("Aucun concept à réviser", "info")
        return
      end

      local concepts = vim.fn.json_decode(table.concat(content, "\n"))
      local now = os.time()
      local due_concepts = {}

      -- Filtrer les concepts dus
      for i, concept in ipairs(concepts) do
        if concept.next_review and concept.next_review <= now then
          table.insert(due_concepts, { idx = i, concept = concept })
        end
      end

      if #due_concepts == 0 then
        vim.notify("Aucun concept à réviser maintenant", "info")
        return
      end

      -- Préparer l'affichage
      local review_concept = due_concepts[1]
      local concept = review_concept.concept
      local idx = review_concept.idx

      local display_text = "# Révision: " .. concept.name .. "\n\n"
      display_text = display_text .. concept.content .. "\n\n"
      display_text = display_text .. "## Évaluation\n\n"
      display_text = display_text .. "1. Très difficile (revoir demain)\n"
      display_text = display_text .. "2. Difficile (revoir dans 3 jours)\n"
      display_text = display_text .. "3. Moyen (revoir dans 1 semaine)\n"
      display_text = display_text .. "4. Facile (revoir dans 2 semaines)\n"
      display_text = display_text .. "5. Très facile (revoir dans 1 mois)\n"

      show_response(display_text)

      -- Gérer l'évaluation
      for i = 1, 5 do
        vim.keymap.set("n", tostring(i), function()
          local intervals = { 1, 3, 7, 14, 30 } -- jours
          local interval = intervals[i]

          -- Mettre à jour le concept
          concepts[idx].review_count = (concepts[idx].review_count or 0) + 1
          concepts[idx].next_review = now + (interval * 24 * 60 * 60)
          concepts[idx].last_difficulty = i

          -- Sauvegarder les modifications
          vim.fn.writefile({ vim.fn.json_encode(concepts) }, config.concepts_storage.path)

          -- Fermer la fenêtre et montrer le message
          vim.cmd("close")
          vim.notify("Concept programmé pour révision dans " .. interval .. " jours", "info")

          -- Continuer avec d'autres révisions si nécessaire
          if #due_concepts > 1 then
            table.remove(due_concepts, 1)
            vim.defer_fn(function()
              review_due_concepts()
            end, 500)
          end
        end, { buffer = 0, silent = true })
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
        -- TECHNIQUES MNÉMONIQUES AVANCÉES (Impact maximal sur la mémorisation)
        { "🧩 Chunking", config.prompts.chunking, "Découpage mémoriel optimisé" },
        { "🏛️ Palais de Mémoire", config.prompts.memory_palace, "Technique de mémorisation spatiale" },
        { "🔄 Double Encodage", config.prompts.dual_coding, "Encodage visuel et verbal" },
        { "❓ Interrogation Élaborative", config.prompts.elaborative_interrogation, "Comprendre par les pourquoi" },
        { "🔍 Difficulté Désirable", config.prompts.desirable_difficulty, "Apprentissage par effort productif" },
        { "🧠 Feynman Inversé", config.prompts.inverted_feynman, "Du simple au complexe et retour" },
        { "🧵 Interleaving Conceptuel", config.prompts.interleaving, "Connexions inter-domaines" },
        { "⏱️ Récupération Temporisée", config.prompts.timed_retrieval, "Protocole de révision programmée" },
        { "🎨 Multi-Sensoriel", config.prompts.multisensory_coding, "Encodage par tous les sens" },

        -- ANALYSE DE PRINCIPES (Compréhension fondamentale)
        { "⚖️ 20/80 Analyse", config.prompts.pareto, "Points critiques et impact maximal" },
        { "🎯 Principes Fondamentaux", config.prompts.core_principles, "Bases essentielles" },
        { "🗺️ Carte Conceptuelle", config.prompts.concept_map, "Visualiser les relations" },

        -- MODÈLES MENTAUX (Structures cognitives)
        { "🔬 Méta-Modèles", config.prompts.meta_programming_model, "Modèles mentaux fondamentaux" },
        { "🐞 Modèles de Débogage", config.prompts.debugging_models, "Modèles pour résolution de problèmes" },
        { "🏗️ Modèles d'Architecture", config.prompts.architecture_models, "Pensée architecturale" },

        -- APPRENTISSAGE PROGRESSIF
        { "🏠 Analogies Quotidiennes", config.prompts.analogies, "Comprendre par comparaison" },
        { "🤔 Questions Socratiques", config.prompts.socratic, "Comprendre par le questionnement" },
        { "📈 Chemin d'Apprentissage", config.prompts.learning_path, "Progression structurée" },
        { "🐛 Correction Misconceptions", config.prompts.misconceptions, "Éviter les erreurs courantes" },

        -- APPLICATIONS PRATIQUES ET OPTIMISATION
        { "🔍 Debug Rapide", config.prompts.quick_debug, "Debugging efficace" },
        { "⚡ Optimisation Rapide", config.prompts.quick_optimize, "Gains rapides" },
        { "👀 Revue Rapide", config.prompts.quick_review, "Revue de code efficace" },
        { "⚡ Optimisation", config.prompts.optimization, "Performance et efficacité" },

        -- PERSPECTIVES AVANCÉES
        { "👨‍🔬 Vision Expert", config.prompts.expert_view, "Perspective avancée" },
        { "🌍 Contexte et Applications", config.prompts.context, "Vue d'ensemble" },
        { "🔄 Approches Alternatives", config.prompts.alternative_approaches, "Différentes solutions" },

        -- STYLES ET PRATIQUES DE CODE
        { "✨ Bonnes Pratiques", config.prompts.best_practices, "Standards et conventions" },
        { "📝 Style de Code", config.prompts.code_style, "Lisibilité et maintenance" },
        { "🚀 Style Carmack", config.prompts.carmack_style, "Approche John Carmack" },
        { "⭐ Style 5 Étoiles", config.prompts.five_stars, "Solution élégante" },

        -- TECHNIQUES SPÉCIFIQUES AVANCÉES
        { "🔍 Full Pointeurs", config.prompts.pointer_magic, "Solution pointeurs" },
        { "⚡ Opérations Binaires", config.prompts.bit_manipulation, "Manipulation bits" },
      }

      vim.ui.select(choices, {
        prompt = "Quelle technique d'apprentissage voulez-vous utiliser?",
        format_item = function(item)
          return string.format("%s - %s", item[1], item[3])
        end,
      }, function(choice)
        if choice then
          -- Interroger l'API
          local content = query_groq(choice[2], text)

          -- Proposer de sauvegarder ce concept pour révision ultérieure
          if content then
            vim.defer_fn(function()
              vim.ui.input({
                prompt = "Nom du concept à sauvegarder (vide pour ignorer): ",
              }, function(concept_name)
                if concept_name and concept_name ~= "" then
                  save_concept(concept_name, text .. "\n\n" .. content)
                end
              end)
            end, 1000) -- Léger délai pour que l'utilisateur ait le temps de voir la réponse
          end
        end
      end)
    end

    -- Vérifier les révisions dues au démarrage
    vim.defer_fn(check_due_reviews, 2000) -- Attendre 2 secondes après le démarrage

    -- Vérifier les révisions dues chaque jour
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        check_due_reviews()
      end,
    })

    -- Création des commandes et mappings
    api.nvim_create_user_command("AskGroq", ask_groq, {})
    api.nvim_create_user_command("ShowSavedConcepts", show_saved_concepts, {})
    api.nvim_create_user_command("ReviewConcepts", review_due_concepts, {})

    vim.keymap.set("v", "<leader>ag", "<cmd>AskGroq<CR>", {
      silent = true,
      desc = "Demander aide Groq",
    })

    vim.keymap.set("n", "<leader>sc", "<cmd>ShowSavedConcepts<CR>", {
      silent = true,
      desc = "Afficher concepts sauvegardés",
    })

    vim.keymap.set("n", "<leader>sr", "<cmd>ReviewConcepts<CR>", {
      silent = true,
      desc = "Réviser concepts dus",
    })

    -- Exposition des modules pour accès externe
    _G.groq_helper = {
      config = config,
      query_groq = query_groq,
      ask_groq = ask_groq,
      save_concept = save_concept,
      show_saved_concepts = show_saved_concepts,
      review_due_concepts = review_due_concepts,
    }
  end,
}
