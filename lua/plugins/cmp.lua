-- ============================================================
-- nvim-cmp + LuaSnip + friendly-snippets
-- ============================================================

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local cmp_ok, cmp = pcall(require, "cmp")
    if not cmp_ok then return end

    local luasnip_ok, luasnip = pcall(require, "luasnip")
    if not luasnip_ok then return end

    -- Load friendly-snippets
    pcall(require, "luasnip.loaders.from_vscode", { lazy = true })

    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and
        vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion    = cmp.config.window.bordered({ border = "rounded" }),
        documentation = cmp.config.window.bordered({ border = "rounded" }),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
        ["<C-f>"]     = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"]     = cmp.mapping.abort(),
        ["<CR>"]      = cmp.mapping.confirm({ select = false }),  -- only confirm explicit selection

        -- Tab: next item or expand/jump snippet
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip",  priority = 750  },
        { name = "buffer",   priority = 500  },
        { name = "path",     priority = 250  },
      }),
      formatting = {
        format = function(entry, vim_item)
          local kind_icons = {
            Text          = "",  Variable       = "",  Module        = "",
            Function      = "󰊕",  Method         = "󰆧",  Constructor   = "",
            Field         = "󰜢",  Property       = "󰖷",  Unit          = "",
            Value         = "󰎠",  Enum           = "",  EnumMember    = "",
            Keyword       = "󰌋",  Snippet        = "",  Color         = "󰏘",
            File          = "󰈙",  Reference      = "",  Folder        = "󰉋",
            Constant      = "󰏿",  Struct         = "󰙅",  Event         = "",
            Operator      = "󰆕",  TypeParameter  = "󰊄",  Class         = "󰠱",
            Interface     = "",
          }
          vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            luasnip  = "[Snip]",
            buffer   = "[Buf]",
            path     = "[Path]",
          })[entry.source.name]
          return vim_item
        end,
      },
      experimental = {
        ghost_text = true,   -- inline preview of top completion item
      },
    })

    -- Cmdline completion for / (search)
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = "buffer" } },
    })

    -- Cmdline completion for : (commands)
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources(
        { { name = "path" } },
        { { name = "cmdline" } }
      ),
    })
  end,
})
