-- lua/plugins/treesitter.lua
-- Deferred until after vim-plug populates rtp on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      vim.notify("nvim-treesitter not installed. Run :PlugInstall", vim.log.levels.WARN)
      return
    end

    configs.setup({
      ensure_installed = {
        "bash", "c", "vimdoc", "json", "lua",
        "markdown", "markdown_inline", "python",
        "rust", "tsx", "typescript", "query",
      },
      auto_install = true,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection  = "<Leader>ss",
          node_incremental = "<Leader>si",
          scope_incremental = "<Leader>sc",
          node_decremental = "<Leader>sd",
        },
      },

      textobjects = {
        select = {
          enable    = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
          },
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"]  = "v",
            ["@class.outer"]     = "<c-v>",
          },
          include_surrounding_whitespace = true,
        },
      },
    })
  end,
})
