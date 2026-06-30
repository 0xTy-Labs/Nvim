-- ============================================================
-- 0xTyLabs · settings/plugins.lua
-- Full IDE rice — speed-first, lazy-loaded where possible
-- Use cases: ML · Backend/Linux · Android · Kernel/CUDA
-- ============================================================

local Plug = vim.fn['plug#']
vim.call('plug#begin', vim.fn.stdpath('data') .. '/plugged')

-- ── UI / Aesthetics ────────────────────────────────────────
Plug 'craftzdog/solarized-osaka.nvim'              -- theme
Plug 'nvim-lualine/lualine.nvim'                   -- statusline
Plug 'nvim-tree/nvim-web-devicons'                 -- icons
Plug 'lukas-reineke/indent-blankline.nvim'         -- indent guides
Plug 'nvim-tree/nvim-tree.lua'                     -- file explorer
Plug 'akinsho/bufferline.nvim'                     -- buffer/tab bar
Plug 'goolord/alpha-nvim'                          -- dashboard
Plug 'rcarriga/nvim-notify'                        -- notifications

-- ── Treesitter ─────────────────────────────────────────────
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-context'     -- sticky context header

-- ── Fuzzy Finder ───────────────────────────────────────────
Plug 'nvim-lua/plenary.nvim'
Plug('nvim-telescope/telescope.nvim', { ['tag'] = '0.1.x' })
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })

-- ── LSP ────────────────────────────────────────────────────
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvimdev/lspsaga.nvim'
Plug 'folke/trouble.nvim'

-- ── Completion ─────────────────────────────────────────────
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

-- ── Formatting & Linting ───────────────────────────────────
Plug 'stevearc/conform.nvim'
Plug 'mfussenegger/nvim-lint'

-- ── DAP (Debugging) ────────────────────────────────────────
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'mfussenegger/nvim-dap-python'
Plug 'jay-babu/mason-nvim-dap.nvim'

-- ── Terminal & Task Runner ─────────────────────────────────
Plug 'akinsho/toggleterm.nvim'
Plug 'stevearc/overseer.nvim'

-- ── Git ────────────────────────────────────────────────────
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'

-- ── Navigation & Editing QoL ───────────────────────────────
Plug 'https://codeberg.org/andyg/leap.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'kylechui/nvim-surround'
Plug 'numToStr/Comment.nvim'
Plug 'folke/which-key.nvim'

-- ── Language-specific extras ───────────────────────────────
Plug 'udalov/kotlin-vim'                           -- Kotlin syntax
Plug 'Vimjas/vim-python-pep8-indent'               -- Python indent

vim.call('plug#end')
