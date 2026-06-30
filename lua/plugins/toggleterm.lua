-- ============================================================
-- 0xTyLabs · plugins/toggleterm.lua
-- Floating terminal + per-project task terminals
-- ============================================================

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local ok, toggleterm = pcall(require, "toggleterm")
    if not ok then return end

    toggleterm.setup({
      size = function(term)
        if term.direction == "horizontal" then return 15
        elseif term.direction == "vertical" then return math.floor(vim.o.columns * 0.4)
        end
      end,
      open_mapping       = [[<C-\>]],
      hide_numbers       = true,
      shade_terminals    = false,
      start_in_insert    = true,
      insert_only_map    = true,
      persist_size       = true,
      persist_mode       = true,
      direction          = "float",
      close_on_exit      = true,
      shell              = vim.o.shell,
      float_opts = {
        border   = "curved",
        width    = math.floor(vim.o.columns * 0.85),
        height   = math.floor(vim.o.lines   * 0.80),
        winblend = 10,
      },
    })

    local Terminal = require("toggleterm.terminal").Terminal

    -- ── Lazygit ──────────────────────────────────────────
    local lazygit = Terminal:new({
      cmd       = "lazygit",
      hidden    = true,
      direction = "float",
      float_opts = { border = "double" },
    })
    vim.keymap.set("n", "<leader>gg", function() lazygit:toggle() end,
      { silent = true, desc = "Lazygit" })

    -- ── Python REPL ───────────────────────────────────────
    local python = Terminal:new({ cmd = "python3", direction = "horizontal", hidden = true })
    vim.keymap.set("n", "<leader>tp", function() python:toggle() end,
      { silent = true, desc = "Python REPL" })

    -- ── ADB shell (Android) ───────────────────────────────
    local adb = Terminal:new({ cmd = "adb shell", direction = "float", hidden = true })
    vim.keymap.set("n", "<leader>ta", function() adb:toggle() end,
      { silent = true, desc = "ADB shell" })

    -- ── Htop (system monitor) ─────────────────────────────
    local htop = Terminal:new({ cmd = "htop", direction = "float", hidden = true })
    vim.keymap.set("n", "<leader>th", function() htop:toggle() end,
      { silent = true, desc = "Htop" })

    -- ── Generic numbered terminals ────────────────────────
    -- <leader>t1 through <leader>t3 for side-by-side work
    for i = 1, 3 do
      vim.keymap.set("n", "<leader>t" .. i,
        "<cmd>" .. i .. "ToggleTerm direction=vertical<CR>",
        { silent = true, desc = "Terminal " .. i .. " (vertical)" })
    end

    -- Terminal mode: easy escape
    vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
  end,
})
