-- ============================================================
-- 0xTyLabs · plugins/lualine.lua
-- solarized-osaka theme — bold sections, LSP name in x
-- ============================================================

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local ok, lualine = pcall(require, "lualine")
    if not ok then return end

    -- LSP server name(s) for the current buffer
    local function lsp_name()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then return "" end
      local names = {}
      for _, c in ipairs(clients) do
        if c.name ~= "null-ls" and c.name ~= "copilot" then
          table.insert(names, c.name)
        end
      end
      if #names == 0 then return "" end
      return " " .. table.concat(names, ", ")
    end

    lualine.setup({
      options = {
        theme                = "solarized-osaka",   -- built-in lualine theme
        globalstatus         = true,
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
        disabled_filetypes   = { statusline = { "alpha", "NvimTree" } },
      },
      sections = {
        lualine_a = {
          { "mode", icon = "", separator = { left = "" }, right_padding = 2 }
        },
        lualine_b = {
          { "branch", icon = "" },
          { "diff",   symbols = { added = " ", modified = " ", removed = " " } },
        },
        lualine_c = {
          {
            "filename",
            path    = 1,
            symbols = { modified = "●", readonly = "", unnamed = "[No Name]" },
          },
        },
        lualine_x = {
          {
            "diagnostics",
            sources  = { "nvim_lsp" },
            symbols  = { error = " ", warn = " ", info = " ", hint = " " },
          },
          lsp_name,
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = {
          { "location", separator = { right = "" }, left_padding = 2 }
        },
      },
      inactive_sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
      },
      extensions = { "nvim-tree", "toggleterm", "trouble", "overseer" },
    })
  end,
})
