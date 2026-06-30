-- ============================================================
-- 0xTyLabs · plugins/telescope.lua
-- ============================================================

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local ok, telescope = pcall(require, "telescope")
    if not ok then return end

    telescope.setup({
      defaults = {
        prompt_prefix   = "  ",
        selection_caret = " ",
        path_display    = { "smart" },
        file_ignore_patterns = {
          "%.git/", "node_modules/", "__pycache__/", "%.gradle/",
          "build/", "%.class$", "%.jar$", "%.apk$",
        },
        layout_config = {
          horizontal = { preview_width = 0.55 },
          vertical   = { mirror = false },
          width      = 0.87,
          height     = 0.80,
        },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-q>"] = require("telescope.actions").send_selected_to_qflist,
            ["<Esc>"] = "close",
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy                   = true,
          override_generic_sorter = true,
          override_file_sorter    = true,
          case_mode               = "smart_case",
        },
      },
    })

    -- Load fzf native (requires `make` to have run)
    pcall(telescope.load_extension, "fzf")

    -- Keymaps
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
    end
    local builtin = require("telescope.builtin")

    map("<leader>ff",  builtin.find_files,                  "Find files")
    map("<leader>fg",  builtin.live_grep,                   "Live grep")
    map("<leader>fb",  builtin.buffers,                     "Find buffers")
    map("<leader>fh",  builtin.help_tags,                   "Help tags")
    map("<leader>fr",  builtin.oldfiles,                    "Recent files")
    map("<leader>fs",  builtin.lsp_document_symbols,        "Document symbols")
    map("<leader>fw",  builtin.lsp_workspace_symbols,       "Workspace symbols")
    map("<leader>fd",  builtin.diagnostics,                 "Diagnostics")
    map("<leader>gc",  builtin.git_commits,                 "Git commits")
    map("<leader>gb",  builtin.git_branches,                "Git branches")
    map("<leader>gs",  builtin.git_status,                  "Git status")
  end,
})
