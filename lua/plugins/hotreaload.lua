-- lua/plugins/dap.lua
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      --------------------------------------------------------------------
      -- 1. Adapters ------------------------------------------------------
      --------------------------------------------------------------------
      local dap = require("dap")

      -- a) GDB >= 14.1 avec support DAP
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-q", "--interpreter=dap" }, -- gdb 14.1+ :contentReference[oaicite:3]{index=3}
      }

      -- b) LLDB (fallback)
      dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode", -- fourni par lldb
      }

      --------------------------------------------------------------------
      -- 2. Configurations C / C++ ---------------------------------------
      --------------------------------------------------------------------
      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            name = "Launch executable",
            type = "gdb", -- ou 'lldb'
            request = "launch",
            program = function()
              return vim.fn.input("Executable : ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            runInTerminal = true,
          },
        }
      end

      --------------------------------------------------------------------
      -- 3. UI + virtual-text --------------------------------------------
      --------------------------------------------------------------------
      require("dapui").setup()
      require("nvim-dap-virtual-text").setup({
        commented = true, -- petites **valeurs** en commentaire
      }) -- :contentReference[oaicite:4]{index=4}

      --------------------------------------------------------------------
      -- 4. Raccourcis ----------------------------------------------------
      --------------------------------------------------------------------
      local map = vim.keymap.set
      map("n", "<F5>", dap.continue)
      map("n", "<F10>", dap.step_over)
      map("n", "<F11>", dap.step_into)
      map("n", "<F12>", dap.step_out)
      map("n", "<Leader>b", dap.toggle_breakpoint)
      map("n", "<Leader>du", require("dapui").toggle)
    end,
  },
}
