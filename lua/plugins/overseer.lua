-- ============================================================
-- 0xTyLabs · plugins/overseer.lua
-- Task runner: make · cmake · gradle · python · cargo
-- ============================================================

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local ok, overseer = pcall(require, "overseer")
    if not ok then return end

    overseer.setup({
      strategy        = "toggleterm",   -- run tasks in toggleterm
      templates       = { "builtin" },  -- auto-detect Makefile, CMake, etc.
      auto_scroll     = true,
      task_list = {
        direction     = "bottom",
        min_height    = 10,
        max_height    = 20,
        default_detail = 1,
      },
    })

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
    end

    map("<leader>or", "<cmd>OverseerRun<CR>",        "Run task")
    map("<leader>ot", "<cmd>OverseerToggle<CR>",     "Toggle task list")
    map("<leader>ob", "<cmd>OverseerBuild<CR>",      "Build")
    map("<leader>oc", function()
      -- Quick build shortcuts per detected project type
      local cwd = vim.fn.getcwd()
      if vim.fn.filereadable(cwd .. "/Makefile") == 1 then
        overseer.run_template({ name = "make" })
      elseif vim.fn.filereadable(cwd .. "/build.gradle") == 1
          or vim.fn.filereadable(cwd .. "/build.gradle.kts") == 1 then
        overseer.new_task({
          name = "Gradle Build",
          cmd  = "./gradlew assembleDebug",
          components = { "default" },
        }):start()
      elseif vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
        overseer.new_task({
          name = "CMake Build",
          cmd  = "cmake --build build",
          components = { "default" },
        }):start()
      elseif vim.fn.filereadable(cwd .. "/Cargo.toml") == 1 then
        overseer.run_template({ name = "cargo build" })
      else
        vim.notify("No recognised build system found", vim.log.levels.WARN)
      end
    end, "Smart build")
  end,
})
