-- ============================================================
-- 0xTyLabs · settings/colorscheme.lua
-- solarized-osaka — night variant, transparent for Hyprland
-- ============================================================

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local ok, osaka = pcall(require, "solarized-osaka")
    if not ok then
      vim.notify("solarized-osaka not installed. Run :PlugInstall", vim.log.levels.WARN)
      return
    end

    osaka.setup({
      transparent    = true,          -- no bg fill — Hyprland compositor handles it
      terminal_colors = true,
      styles = {
        comments   = { italic = true },
        keywords   = { italic = true },
        functions  = {},
        variables  = {},
        sidebars   = "dark",          -- NvimTree, qf, help get darker bg
        floats     = "dark",          -- floating windows get darker bg
      },
      sidebars = { "qf", "help", "NvimTree", "toggleterm", "Trouble" },
      dim_inactive      = false,
      lualine_bold      = true,
      hide_inactive_statusline = false,

      on_colors = function(colors)
        -- Slightly brighten hint so it reads on dark bg
        colors.hint = colors.cyan
      end,

      on_highlights = function(hl, c)
        -- ── Telescope (borderless style matching craftzdog's own config) ──
        local prompt_bg = c.bg_dark
        hl.TelescopeNormal         = { bg = c.bg_dark,  fg = c.fg_dark }
        hl.TelescopeBorder         = { bg = c.bg_dark,  fg = c.bg_dark }
        hl.TelescopePromptNormal   = { bg = prompt_bg }
        hl.TelescopePromptBorder   = { bg = prompt_bg,  fg = prompt_bg }
        hl.TelescopePromptTitle    = { bg = prompt_bg,  fg = prompt_bg }
        hl.TelescopePreviewTitle   = { bg = c.bg_dark,  fg = c.bg_dark }
        hl.TelescopeResultsTitle   = { bg = c.bg_dark,  fg = c.bg_dark }

        -- ── Completion popup ──────────────────────────────────────────────
        hl.Pmenu      = { bg = c.bg_dark, fg = c.fg }
        hl.PmenuSel   = { bg = c.bg_highlight, fg = c.fg, bold = true }
        hl.PmenuSbar  = { bg = c.bg_dark }
        hl.PmenuThumb = { bg = c.fg_gutter }

        -- ── Float borders ─────────────────────────────────────────────────
        hl.FloatBorder = { fg = c.border_highlight, bg = "NONE" }
        hl.NormalFloat = { bg = "NONE" }

        -- ── Which-key ─────────────────────────────────────────────────────
        hl.WhichKeyFloat = { bg = c.bg_dark }

        -- ── LSPSaga ───────────────────────────────────────────────────────
        hl.SagaBorder   = { fg = c.border_highlight, bg = "NONE" }

        -- ── Gutter: no background bleed ───────────────────────────────────
        hl.SignColumn   = { bg = "NONE" }
        hl.LineNr       = { fg = c.dark5, bg = "NONE" }
        hl.CursorLineNr = { fg = c.orange, bold = true, bg = "NONE" }

        -- ── NvimTree ──────────────────────────────────────────────────────
        hl.NvimTreeNormal     = { bg = "NONE" }
        hl.NvimTreeEndOfBuffer = { bg = "NONE" }

        -- ── Bufferline slant fill on transparent bg ───────────────────────
        hl.BufferLineOffsetSeparator = { fg = c.border, bg = "NONE" }
      end,
    })

    vim.cmd("colorscheme solarized-osaka")
  end,
})
