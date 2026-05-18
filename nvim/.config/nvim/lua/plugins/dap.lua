return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mason-org/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = { "delve", "debugpy", "js-debug-adapter" },
      handlers = {
        -- delve (Go) and debugpy (Python) are handled by lang.go and lang.python extras
        -- js-debug-adapter needs manual setup
        ["js-debug-adapter"] = function() end,
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      local dap = require("dap")

      -- find the js-debug-adapter binary installed by Mason
      local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_path, "${port}" },
        },
      }

      -- reuse the same adapter for chrome-based debugging
      dap.adapters["pwa-chrome"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_path, "${port}" },
        },
      }

      local js_languages = { "javascript", "typescript", "javascriptreact", "typescriptreact" }

      for _, lang in ipairs(js_languages) do
        dap.configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file (Node)",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process (Node)",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
          },
        }
      end
    end,
  },
}
