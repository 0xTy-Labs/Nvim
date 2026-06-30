-- ============================================================
-- 0xTyLabs · settings/mappings.lua
-- Global keymaps (plugin-specific keymaps live in plugin files)
-- ============================================================

local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true, desc = desc })
end

-- ── Leader ───────────────────────────────────────────────
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

-- ── Better window navigation ─────────────────────────────
map("n", "<C-h>", "<C-w>h", "Move to left window")
map("n", "<C-j>", "<C-w>j", "Move to bottom window")
map("n", "<C-k>", "<C-w>k", "Move to top window")
map("n", "<C-l>", "<C-w>l", "Move to right window")

-- ── Resize windows ───────────────────────────────────────
map("n", "<C-Up>",    "<cmd>resize +2<CR>",          "Increase height")
map("n", "<C-Down>",  "<cmd>resize -2<CR>",          "Decrease height")
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", "Decrease width")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", "Increase width")

-- ── Better indenting ─────────────────────────────────────
map("v", "<", "<gv", "Indent left (keep selection)")
map("v", ">", ">gv", "Indent right (keep selection)")

-- ── Move lines ───────────────────────────────────────────
map("n", "<A-j>", "<cmd>m .+1<CR>==",         "Move line down")
map("n", "<A-k>", "<cmd>m .-2<CR>==",         "Move line up")
map("v", "<A-j>", ":m '>+1<CR>gv=gv",        "Move selection down")
map("v", "<A-k>", ":m '<-2<CR>gv=gv",        "Move selection up")

-- ── Buffer management ────────────────────────────────────
map("n", "<leader>bd", "<cmd>bdelete<CR>",    "Delete buffer")
map("n", "<leader>bD", "<cmd>bdelete!<CR>",   "Force delete buffer")
map("n", "<leader>bn", "<cmd>bnext<CR>",      "Next buffer")
map("n", "<leader>bp", "<cmd>bprevious<CR>",  "Prev buffer")

-- ── Clear search highlight ───────────────────────────────
map("n", "<leader>h", "<cmd>nohlsearch<CR>", "Clear search highlight")

-- ── Save / Quit ──────────────────────────────────────────
map("n", "<C-s>",      "<cmd>w<CR>",          "Save")
map("n", "<leader>w",  "<cmd>w<CR>",          "Save")
map("n", "<leader>q",  "<cmd>q<CR>",          "Quit")
map("n", "<leader>Q",  "<cmd>qa!<CR>",        "Force quit all")

-- ── Paste without yanking (keep register) ────────────────
map("v", "p", '"_dP', "Paste without yanking")

-- ── Yank to end of line (consistent with D, C) ───────────
map("n", "Y", "y$", "Yank to end of line")

-- ── Keep cursor centred when jumping ─────────────────────
map("n", "<C-d>", "<C-d>zz", "Scroll down (centred)")
map("n", "<C-u>", "<C-u>zz", "Scroll up (centred)")
map("n", "n",     "nzzzv",   "Next search result (centred)")
map("n", "N",     "Nzzzv",   "Prev search result (centred)")

-- ── Trouble (diagnostics panel) ──────────────────────────
map("n", "<leader>xx", "<cmd>TroubleToggle<CR>",                      "Trouble toggle")
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>","Trouble workspace")
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", "Trouble document")
map("n", "<leader>xl", "<cmd>TroubleToggle loclist<CR>",              "Trouble loclist")
map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<CR>",             "Trouble quickfix")

-- ── Lspsaga (hover docs, outline) ────────────────────────
map("n", "<leader>lo", "<cmd>Lspsaga outline<CR>",        "Symbol outline")
map("n", "<leader>lf", "<cmd>Lspsaga finder<CR>",         "LSP finder")
map("n", "<leader>lk", "<cmd>Lspsaga hover_doc<CR>",      "Hover doc")
map("n", "<leader>lr", "<cmd>Lspsaga rename<CR>",         "Rename")
map("n", "<leader>la", "<cmd>Lspsaga code_action<CR>",    "Code action")
map("n", "<leader>ld", "<cmd>Lspsaga peek_definition<CR>","Peek definition")

-- ── Mason ────────────────────────────────────────────────
map("n", "<leader>m", "<cmd>Mason<CR>", "Mason")
