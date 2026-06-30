-- ============================================================
-- 0xTyLabs · plugins/nvim-tree.lua
-- ============================================================

-- Disable netrw immediately (must be before nvim-tree loads)
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local ok, nvimtree = pcall(require, "nvim-tree")
    if not ok then return end

    nvimtree.setup({
      hijack_cursor    = true,
      sync_root_with_cwd = true,
      view = {
        width        = 32,
        side         = "left",
        number       = false,
        relativenumber = false,
      },
      renderer = {
        root_folder_label = ":~:s?$?/..?",
        highlight_git      = true,
        indent_markers     = { enable = true },
        icons = {
          glyphs = {
            default  = "",
            symlink  = "",
            folder   = {
              arrow_closed = "",
              arrow_open   = "",
              default      = "",
              open         = "",
              empty        = "",
              empty_open   = "",
              symlink      = "",
              symlink_open = "",
            },
            git = {
              unstaged  = "✗",
              staged    = "✓",
              unmerged  = "",
              renamed   = "➜",
              untracked = "★",
              deleted   = "",
              ignored   = "◌",
            },
          },
        },
      },
      filters = {
        dotfiles = false,      -- show hidden files
        custom   = { "^.git$", "^node_modules$", "^.gradle$", "__pycache__" },
      },
      git = {
        enable  = true,
        ignore  = false,
        timeout = 400,
      },
      actions = {
        open_file = {
          quit_on_open = false,
          resize_window = true,
        },
      },
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs,
            { buffer = bufnr, noremap = true, silent = true, nowait = true, desc = "NvimTree: " .. desc })
        end
        -- defaults
        api.config.mappings.default_on_attach(bufnr)
        -- custom overrides
        map("l",  api.node.open.edit,          "Open")
        map("h",  api.node.navigate.parent_close, "Close directory")
        map("v",  api.node.open.vertical,      "Open vsplit")
        map("<CR>", api.node.open.edit,        "Open")
      end,
    })

    -- Toggle keymaps
    vim.keymap.set("n", "<leader>e",  "<cmd>NvimTreeToggle<CR>",   { silent = true, desc = "Explorer toggle" })
    vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { silent = true, desc = "Explorer find file" })
  end,
})
