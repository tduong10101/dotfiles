return {
  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    cmd = { "Codeium" },
    init = function()
      vim.g.codeium_no_map_tab = 1
    end,
    config = function()
      vim.keymap.set("i", "<M-]>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true, silent = true })
      vim.keymap.set("i", "<M-[>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true, silent = true })
      vim.keymap.set("i", "<M-e>", function() return vim.fn["codeium#Clear"]() end, { expr = true, silent = true })
    end,
  },
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.select_next()
            end
            local text = vim.fn["codeium#Accept"]()
            if text and text ~= "" then
              vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes(text, true, true, true),
                "in",
                false
              )
              return true
            end
          end,
          "snippet_forward",
          "fallback",
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
