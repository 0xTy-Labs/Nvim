-- ============================================================
-- 0xTyLabs · plugins/qol.lua
-- leap · autopairs · surround · comment · which-key
-- bufferline · indent-blankline · nvim-notify · ts-context
-- ============================================================

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()

    -- ── leap ─────────────────────────────────────────────
    -- add_default_mappings() is deprecated; set keymaps explicitly
    local leap_ok, leap = pcall(require, "leap")
    if leap_ok then
      leap.setup({})   -- use defaults
      -- s/S = forward/backward jump (Sneak-style, exclusive pair)
      vim.keymap.set({ "n", "x", "o" }, "s",  "<Plug>(leap-forward)",          { desc = "Leap forward" })
      vim.keymap.set({ "n", "x", "o" }, "S",  "<Plug>(leap-backward)",         { desc = "Leap backward" })
      vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)",      { desc = "Leap from window" })
    end

    -- ── autopairs ────────────────────────────────────────
    local ap_ok, autopairs = pcall(require, "nvim-autopairs")
    if ap_ok then
      autopairs.setup({
        check_ts         = true,
        disable_filetype = { "TelescopePrompt" },
        fast_wrap = { map = "<M-e>", keys = "qwertyuiopzxcvbnmasdfghjkl" },
      })
      local cmp_ap_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
      local cmp_ok,    cmp           = pcall(require, "cmp")
      if cmp_ap_ok and cmp_ok then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end

    -- ── surround ─────────────────────────────────────────
    local sur_ok, surround = pcall(require, "nvim-surround")
    if sur_ok then surround.setup() end

    -- ── Comment.nvim ─────────────────────────────────────
    local com_ok, comment = pcall(require, "Comment")
    if com_ok then comment.setup() end

    -- ── which-key ────────────────────────────────────────
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.setup({
        plugins = { marks = true, registers = true, spelling = { enabled = false } },
        window  = { border = "rounded", padding = { 1, 2, 1, 2 } },
        layout  = { align = "center" },
      })
      wk.register({
        ["<leader>f"]  = { name = "󰍉 Find" },
        ["<leader>g"]  = { name = " Git" },
        ["<leader>h"]  = { name = " Hunks" },
        ["<leader>o"]  = { name = " Overseer" },
        ["<leader>t"]  = { name = " Terminal" },
        ["<leader>d"]  = { name = " Debug" },
        ["<leader>l"]  = { name = " LSP" },
        ["<leader>x"]  = { name = " Diagnostics" },
        ["<leader>b"]  = { name = " Buffer" },
        ["<leader>e"]  = { name = " Explorer" },
      })
    end

    -- ── bufferline ───────────────────────────────────────
    local bl_ok, bufferline = pcall(require, "bufferline")
    if bl_ok then
      bufferline.setup({
        options = {
          mode         = "buffers",
          numbers      = "ordinal",
          diagnostics  = "nvim_lsp",
          diagnostics_indicator = function(_, _, diag)
            local icons = { error = " ", warning = " " }
            local ret = (diag.error and icons.error .. diag.error or "")
                     .. (diag.warning and icons.warning .. diag.warning or "")
            return vim.trim(ret)
          end,
          offsets = {
            { filetype = "NvimTree", text = "Explorer",
              highlight = "Directory", separator = true }
          },
          separator_style         = "slant",
          show_buffer_close_icons = true,
          show_close_icon         = false,
          color_icons             = true,
        },
      })
      vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>",
        { silent = true, desc = "Next buffer" })
      vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>",
        { silent = true, desc = "Prev buffer" })
      for i = 1, 9 do
        vim.keymap.set("n", "<leader>" .. i,
          "<cmd>BufferLineGoToBuffer " .. i .. "<CR>",
          { silent = true, desc = "Buffer " .. i })
      end
    end

    -- ── indent-blankline ─────────────────────────────────
    -- Must run after ColorScheme so IblScope highlight group exists.
    -- Using a nested autocmd here instead of the outer VimEnter.
    vim.api.nvim_create_autocmd("ColorScheme", {
      once = true,
      callback = function()
        local ibl_ok, ibl = pcall(require, "ibl")
        if not ibl_ok then return end
        ibl.setup({
          indent  = { char = "│", tab_char = "│" },
          scope   = { enabled = true, show_start = true },
          exclude = {
            filetypes = { "alpha", "help", "NvimTree",
                          "Trouble", "toggleterm", "lazy" },
          },
        })
      end,
    })

    -- ── nvim-notify ──────────────────────────────────────
    local notify_ok, notify = pcall(require, "notify")
    if notify_ok then
      notify.setup({
        background_colour = "#002b36",   -- solarized base03
        fps               = 60,
        stages            = "fade_in_slide_out",
        timeout           = 3000,
        top_down          = true,
      })
      vim.notify = notify
    end

    -- ── treesitter-context ───────────────────────────────
    local ctx_ok, ctx = pcall(require, "treesitter-context")
    if ctx_ok then
      ctx.setup({
        enable              = true,
        max_lines           = 4,
        min_window_height   = 20,
        line_numbers        = true,
        multiline_threshold = 20,
        trim_scope          = "outer",
        mode                = "cursor",
      })
      vim.keymap.set("n", "[x",
        function() ctx.go_to_context(vim.v.count1) end,
        { silent = true, desc = "Go to context" })
    end

  end,
})
