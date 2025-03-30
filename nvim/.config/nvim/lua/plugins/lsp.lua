return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    config = function()
      require("mason").setup()
      local nmap = function(keys, func, desc)
        if desc then
          desc = "LSP: " .. desc
        end
      end

      nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
      nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    end
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
}
