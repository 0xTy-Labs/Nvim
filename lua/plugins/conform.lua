-- ============================================================
-- Formatters: black · ruff · clang-format · ktlint · stylua · shfmt
-- ============================================================

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local ok, conform = pcall(require, "conform")
    if not ok then return end

    conform.setup({
      formatters_by_ft = {
        -- ML / Python
        python     = { "ruff_format", "black" },   -- ruff first, black fallback

        -- Kernel / C / C++ / CUDA
        c          = { "clang_format" },
        cpp        = { "clang_format" },
        cuda       = { "clang_format" },

        -- Android / Kotlin / Java
        kotlin     = { "ktlint" },
        java       = { "google_java_format" },

        -- Backend / Shell
        sh         = { "shfmt" },
        bash       = { "shfmt" },
        dockerfile = {},                            -- no formatter, use linter

        -- Lua (nvim config)
        lua        = { "stylua" },

        -- Web / Data
        json       = { "prettier" },
        yaml       = { "prettier" },
        markdown   = { "prettier" },

        -- Rust
        rust       = { "rustfmt" },

        -- Fallback
        ["*"]      = { "trim_whitespace" },
      },

      format_on_save = {
        timeout_ms = 800,
        lsp_fallback = true,   -- use LSP formatter if conform has nothing
      },

      formatters = {
        clang_format = {
          prepend_args = {
            "--style={ BasedOnStyle: llvm, IndentWidth: 4, ColumnLimit: 100 }",
          },
        },
        shfmt = {
          prepend_args = { "-i", "4", "-ci" },    -- 4-space indent, case indent
        },
      },
    })

    -- Manual format keymap (in addition to format-on-save)
    vim.keymap.set({ "n", "v" }, "<leader>F", function()
      conform.format({ async = true, lsp_fallback = true })
    end, { silent = true, desc = "Format buffer/selection" })
  end,
})
