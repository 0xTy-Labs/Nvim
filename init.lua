-- ============================================================
-- 0xTyLabs neovim config
-- Inspired By:
--   Bread        @https://github.com/BreadOnPenguins
--   Takuya        @https://github.com/craftzdog
--   Mariusz       @https://github.com/vhyrro
-- ============================================================


local data_dir = vim.fn.stdpath("data")
if vim.fn.empty(vim.fn.glob(data_dir .. "/site/autoload/plug.vim")) == 1 then
  vim.cmd(
    "silent !curl -fLo " .. data_dir .. "/site/autoload/plug.vim"
    .. " --create-dirs "
    .. "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  )
  vim.o.runtimepath = vim.o.runtimepath
  vim.cmd("autocmd VimEnter * PlugInstall --sync | source $MYVIMRC")
end


vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

require("settings.options")    -- vim.opt settings
require("settings.keymaps")    -- global keymaps

require("settings.plugins")

require("settings.alpha")
require("settings.colorscheme")

require("settings.autocmd")

require("plugins.treesitter")
require("plugins.lualine")
require("plugins.nvim-tree")
require("plugins.telescope")
require("plugins.lsp")
require("plugins.cmp")
require("plugins.conform")
require("plugins.gitsigns")
require("plugins.toggleterm")
require("plugins.overseer")
require("plugins.qol")          -- leap · autopairs · surround · comment · which-key
                                 -- bufferline · indent-blankline · notify · ts-context
