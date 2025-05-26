-- lua/plugins/gamified.lua
-- Single “pack” that groups all the gamification‑oriented plugins in one place.
-- Drop this file into your `lua/plugins/` directory; Lazy.nvim will pick it up automatically.
--
-- Each entry is tuned for minimal startup cost:
--   • anything that should always be active (XP trackers) loads on the `VeryLazy` event
--   • training tools and games are `cmd`‑loaded so they don’t touch startup
--   • a few extras use smart events (`InsertEnter`, `BufReadPost`, …)
--
return {

  ---------------------------------------------------------------------------
  -- 1. Progress trackers / XP
  ---------------------------------------------------------------------------
  {
    "GrzegorzSzczepanek/gamify.nvim",
    event = "VeryLazy",
    opts = true,
  },
  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
  },
  {
    "vonPB/aw-watcher.nvim",
    cond = function()
      return vim.fn.executable("aw-client") == 1
    end,
    event = "VeryLazy",
  },
  {
    "jcdickinson/wpm.nvim",
    event = "InsertEnter",
  },

  ------------------------------------------------------------------------------
  ----- 2. Practice / habit building
  ------------------------------------------------------------------------------
  ----- {
  -----   "m4xshen/hardtime.nvim",
  -----   event = { "BufReadPost", "BufNewFile" },
  -----   opts = {
  -----     disabled_filetypes = { "TelescopePrompt", "alpha", "dashboard" },
  -----   },
  ------------------------------------------------------------------------------
  ---},
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
  },
  {
    "kawre/leetcode.nvim",
    cmd = { "Leet", "LeetTest", "LeetSubmit" },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "NStefan002/speedtyper.nvim",
    branch = "v2",
    cmd = "Speedtyper",
  },

  ---------------------------------------------------------------------------
  -- 3. Mini‑games (command‑loaded)
  ---------------------------------------------------------------------------
  { "alec-gibson/nvim-tetris", cmd = "Tetris" },
  { "seandewar/nvimesweeper", cmd = "Nvimesweeper" },
  { "seandewar/killersheep.nvim", cmd = "KillKillKill" },
  { "alanfortlink/blackjack.nvim", cmd = "Blackjack", dependencies = { "nvim-lua/plenary.nvim" } },
  { "jim-fx/sudoku.nvim", cmd = "Sudoku", opts = true },
  { "rktjmp/shenzhen-solitaire.nvim", cmd = "ShenzhenSolitaire" },

  ---------------------------------------------------------------------------
  -- 4. Screensaver / eye‑candy
  ---------------------------------------------------------------------------
  { "Eandrju/cellular-automaton.nvim", cmd = "CellularAutomaton" },
}
