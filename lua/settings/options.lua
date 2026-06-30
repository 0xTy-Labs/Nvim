-- ============================================================
-- 0xTyLabs · settings/options.lua
-- ============================================================

local opt = vim.opt

-- ── Appearance ───────────────────────────────────────────
opt.termguicolors  = true
opt.number         = true
opt.relativenumber = true
opt.signcolumn     = "yes"       -- always show gutter (no layout shift)
opt.cursorline     = true
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.wrap           = false
opt.colorcolumn    = "100"       -- soft column limit
opt.showmode       = false       -- lualine handles this
opt.laststatus     = 3           -- single global statusline (nvim 0.7+)
opt.cmdheight      = 1
opt.pumheight      = 12          -- max completion popup items
opt.pumblend       = 10          -- popup transparency
opt.winblend       = 10          -- floating window transparency

-- ── Editing ──────────────────────────────────────────────
opt.expandtab      = true
opt.shiftwidth     = 4
opt.tabstop        = 4
opt.softtabstop    = 4
opt.smartindent    = true
opt.autoindent     = true
opt.breakindent    = true        -- wrapped lines keep indent

-- ── Search ───────────────────────────────────────────────
opt.hlsearch       = true
opt.incsearch      = true
opt.ignorecase     = true
opt.smartcase      = true        -- case-sensitive if uppercase present

-- ── Files ────────────────────────────────────────────────
opt.undofile       = true        -- persistent undo
opt.undodir        = vim.fn.stdpath("data") .. "/undo"
opt.backup         = false
opt.swapfile       = false
opt.fileencoding   = "utf-8"
opt.autoread       = true        -- auto-reload files changed on disk

-- ── Performance ──────────────────────────────────────────
opt.updatetime     = 150         -- faster CursorHold (gitsigns, LSP)
opt.timeoutlen     = 300         -- which-key trigger time
opt.redrawtime     = 1500
opt.synmaxcol      = 240         -- don't highlight past column 240

-- ── Splits ───────────────────────────────────────────────
opt.splitright     = true        -- vsplit opens right
opt.splitbelow     = true        -- split opens below

-- ── Clipboard ────────────────────────────────────────────
opt.clipboard      = "unnamedplus"   -- share with system clipboard (Wayland)

-- ── Completion ───────────────────────────────────────────
opt.completeopt    = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")            -- no "match 1 of N" messages

-- ── Folds (treesitter) ───────────────────────────────────
opt.foldmethod     = "expr"
opt.foldexpr       = "nvim_treesitter#foldexpr()"
opt.foldlevel      = 99              -- open all folds by default

-- ── Misc ─────────────────────────────────────────────────
opt.mouse          = "a"
opt.conceallevel   = 0               -- don't hide markdown syntax
opt.list           = true
opt.listchars      = { tab = "→ ", trail = "·", nbsp = "␣" }
opt.virtualedit    = "block"         -- block selection past EOL
opt.inccommand     = "split"         -- live preview of :s substitutions
