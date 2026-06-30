-- ============================================================
-- Mason → vim.lsp.config (nvim 0.11+ native API)
-- Servers: python · kotlin/java · c/c++/cuda · lua · bash · rust
-- ============================================================

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()

    -- ── Mason ─────────────────────────────────────────────
    local mason_ok, mason = pcall(require, "mason")
    if not mason_ok then
      vim.notify("mason.nvim not installed. Run :PlugInstall", vim.log.levels.WARN)
      return
    end

    mason.setup({
      ui = {
        border = "rounded",
        icons  = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
      },
    })

    -- ── mason-lspconfig ───────────────────────────────────
    local mlsp_ok, mlsp = pcall(require, "mason-lspconfig")
    if not mlsp_ok then return end

    mlsp.setup({
      ensure_installed = {
        "pyright",                   -- Python/ML static analysis
        "ruff",                      -- Python linting + formatting (ruff_lsp is deprecated)
        "bashls",                    -- Bash/shell
        "dockerls",                  -- Dockerfile
        "yamlls",                    -- YAML / CI
        "jsonls",                    -- JSON
        "kotlin_language_server",    -- Android / Kotlin
        "jdtls",                     -- Android / Java
        "clangd",                    -- C / C++ / CUDA / kernel
        "lua_ls",                    -- Lua / nvim config
        "rust_analyzer",             -- Rust
      },
      automatic_installation = true,
    })

    -- ── Capabilities (cmp-extended) ───────────────────────
    local caps = vim.lsp.protocol.make_client_capabilities()
    local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if cmp_ok then
      caps = cmp_lsp.default_capabilities(caps)
    end

    -- ── Keymaps on attach ─────────────────────────────────
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("oxtylabs_lsp_maps", { clear = true }),
      callback = function(ev)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
        end
        map("n", "gd",         vim.lsp.buf.definition,      "Go to definition")
        map("n", "gD",         vim.lsp.buf.declaration,     "Go to declaration")
        map("n", "gi",         vim.lsp.buf.implementation,  "Go to implementation")
        map("n", "gr",         vim.lsp.buf.references,      "Find references")
        map("n", "gt",         vim.lsp.buf.type_definition, "Go to type def")
        map("n", "K",          vim.lsp.buf.hover,           "Hover docs")
        map("n", "<C-k>",      vim.lsp.buf.signature_help,  "Signature help")
        map("n", "<leader>rn", vim.lsp.buf.rename,          "Rename symbol")
        map("n", "<leader>ca", vim.lsp.buf.code_action,     "Code action")
        map("n", "<leader>f",  function() vim.lsp.buf.format({ async = true }) end, "Format")
        map("n", "[d",         vim.diagnostic.goto_prev,    "Prev diagnostic")
        map("n", "]d",         vim.diagnostic.goto_next,    "Next diagnostic")
        map("n", "<leader>e",  vim.diagnostic.open_float,   "Float diagnostic")
        map("n", "<leader>q",  vim.diagnostic.setloclist,   "Diagnostic list")
      end,
    })

    -- ── Diagnostic UI ─────────────────────────────────────
    vim.diagnostic.config({
      virtual_text     = { prefix = "●", source = "if_many" },
      signs            = true,
      underline        = true,
      update_in_insert = false,
      severity_sort    = true,
      float            = { border = "rounded", source = "always" },
    })

    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- ── Per-server configs via vim.lsp.config ─────────────
    -- nvim 0.11+ native API — no more require('lspconfig') framework

    -- Python / ML
    vim.lsp.config("pyright", { capabilities = caps })
    vim.lsp.config("ruff", { capabilities = caps })   -- was ruff_lsp, now just ruff

    -- Backend / Linux
    vim.lsp.config("bashls",   { capabilities = caps })
    vim.lsp.config("dockerls", { capabilities = caps })
    vim.lsp.config("yamlls", {
      capabilities = caps,
      settings = {
        yaml = {
          schemas = {
            ["https://json.schemastore.org/github-workflow.json"]  = "/.github/workflows/*.yml",
            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
          },
        },
      },
    })
    vim.lsp.config("jsonls", { capabilities = caps })

    -- Android / Kotlin  (jdtls is per-project; see ftplugin/java.lua)
    vim.lsp.config("kotlin_language_server", { capabilities = caps })

    -- Kernel / C / C++ / CUDA
    vim.lsp.config("clangd", {
      capabilities = caps,
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
        "--cuda-path=/usr/local/cuda",
      },
      filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
      root_markers = {
        "compile_commands.json", "compile_flags.txt",
        ".clangd", "CMakeLists.txt", "Makefile", ".git",
      },
    })

    -- Lua (nvim config)
    vim.lsp.config("lua_ls", {
      capabilities = caps,
      settings = {
        Lua = {
          runtime     = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace   = {
            library         = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })

    -- Rust
    vim.lsp.config("rust_analyzer", {
      capabilities = caps,
      settings = {
        ["rust-analyzer"] = {
          cargo       = { allFeatures = true },
          checkOnSave = { command = "clippy" },
        },
      },
    })

    -- ── Enable all configured servers ─────────────────────
    vim.lsp.enable({
      "pyright", "ruff",
      "bashls", "dockerls", "yamlls", "jsonls",
      "kotlin_language_server",
      "clangd",
      "lua_ls",
      "rust_analyzer",
    })

  end,
})
