return {
  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.install").prefer_git = true
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
      -- see `:help nvim-treesitter`

      -- indent level at which it folds
      vim.opt.foldlevel = 20
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

      require("nvim-treesitter.configs").setup({
        -- add languages to be installed here that you want installed for treesitter
        ensure_installed = { "cpp", "lua", "rust", "tsx", "typescript", "vim", "elixir" },
        auto_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<m-space>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- you can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]]"] = "@function.outer",
              ["]n"] = "@class.outer",
            },
            goto_next_end = {
              ["]["] = "@function.outer",
              ["]n"] = "@class.outer",
            },
            goto_previous_start = {
              ["[["] = "@function.outer",
              ["[n"] = "@class.outer",
            },
            goto_previous_end = {
              ["[]"] = "@function.outer",
              ["[n"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>a"] = "@parameter.inner",
            },
          },
        },
      })
      vim.api.nvim_create_autocmd("bufenter", {
        pattern = {
          "fastfile",
          "appfile",
          "matchfile",
          "pluginfile",
          "podfile",
        },
        callback = function()
          vim.o.filetype = "ruby"
        end,
      })
      vim.api.nvim_create_autocmd("bufenter", {
        pattern = {
          "*.env.*",
        },
        callback = function()
          vim.o.filetype = "sh"
        end,
      })
      vim.api.nvim_create_autocmd("bufenter", {
        pattern = {
          "*.code-snippets",
        },
        callback = function()
          vim.o.filetype = "jsonc"
        end,
      })
    end,
  },
}
