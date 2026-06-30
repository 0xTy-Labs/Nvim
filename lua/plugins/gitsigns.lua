
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local ok, gitsigns = pcall(require, "gitsigns")
    if not ok then return end

    gitsigns.setup({
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },
      signcolumn          = true,
      numhl               = false,
      linehl              = false,
      word_diff           = false,
      watch_gitdir        = { follow_files = true },
      attach_to_untracked = true,
      current_line_blame  = true,
      current_line_blame_opts = {
        virt_text         = true,
        virt_text_pos     = "eol",
        delay             = 800,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> · <summary>",
      on_attach = function(bufnr)
        local gs  = package.loaded.gitsigns
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs,
            { buffer = bufnr, silent = true, desc = desc })
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, "Next hunk")
        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, "Prev hunk")

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk,                   "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk,                   "Reset hunk")
        map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk (visual)")
        map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk (visual)")
        map("n", "<leader>hS", gs.stage_buffer,                 "Stage buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk,              "Undo stage hunk")
        map("n", "<leader>hR", gs.reset_buffer,                 "Reset buffer")
        map("n", "<leader>hp", gs.preview_hunk,                 "Preview hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>hd", gs.diffthis,                     "Diff this")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff this ~")

        -- Text objects
        map({ "o", "x" }, "ih", "<cmd>Gitsigns select_hunk<CR>", "Select hunk")
      end,
    })
  end,
})
