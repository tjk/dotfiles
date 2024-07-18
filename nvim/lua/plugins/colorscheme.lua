-- return {
--   "maxmx03/solarized.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     -- require("solarized").setup({
--     --   tree = true, -- TODO this is not working
--     -- })
--     vim.cmd.colorscheme("solarized")
--   end,
-- }
-- return {
--   "morhetz/gruvbox",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme("gruvbox")
--   end,
-- }
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    vim.cmd.colorscheme("tokyonight")
  end,
}
