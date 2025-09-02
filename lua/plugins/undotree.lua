return {
  "mbbill/undotree",

  config = function()
    vim.keymap.set("n", "<leader>p", vim.cmd.UndotreeToggle)
  end,
}
