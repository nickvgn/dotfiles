return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
  },
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      notification = {
        window = {
          normal_hl = "Comment", -- Base highlight group in the notification window
          winblend = 0,          -- Background color opacity in the notification window
          border = "none",       -- Border around the notification window
          zindex = 45,           -- Stacking priority of the notification window
          max_width = 60,        -- Maximum width of the notification window
          max_height = 0,        -- Maximum height of the notification window
          x_padding = 1,         -- Padding from right edge of window boundary
          y_padding = 0,         -- Padding from bottom edge of window boundary
          align = "bottom",      -- How to align the notification window
          relative = "editor",   -- What the notification window position is relative to
        },
      },
    }
  },
  {
    "elixir-tools/elixir-tools.nvim",
    ft = { "elixir" },
    version = "*",
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup({
        nextls = { enable = true },
        elixirls = {
          enable = true,
          settings = elixirls.settings({
            dialyzerEnabled = true,
            fetchDeps = true,
            enableTestLenses = true,
          }),
          on_attach = function(client, bufnr)
            vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
            vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
            vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
          end,
        },
        projectionist = {
          enable = true,
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
  }
}
