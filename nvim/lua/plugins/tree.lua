return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      actions = {
        open_file = {
          -- quit_on_open = true,
          window_picker = {
            enable = false
          },
        },
      },
      -- don't need this with quit_on_open
      update_focused_file = {
        enable = true,
      },
    })
  end,
}
