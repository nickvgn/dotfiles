return {
	-- Detect tabstop and shiftwidth automatically
	{
		"tpope/vim-sleuth",
		lazy = true,
	},

	-- Additional lua configuration, makes nvim stuff amazing!
	{
		"folke/neodev.nvim",
		ft = "lua",
		config = function()
			-- Setup neovim lua configuration
			require("neodev").setup()
		end,
	},

	-- {
	-- 	"mfussenegger/nvim-lint",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		vim.env.ESLINT_D_PPID = vim.fn.getpid()
	-- 		require("lint").linters_by_ft = {
	-- 			javascript = { "eslint_d" },
	-- 			typescript = { "eslint_d" },
	-- 			typescriptreact = { "eslint_d" },
	-- 			javascriptreact = { "eslint_d" },
	-- 		}
	-- 		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	-- 			callback = function()
	-- 				-- try_lint without arguments runs the linters defined in `linters_by_ft`
	-- 				-- for the current filetype
	-- 				require("lint").try_lint()
	-- 			end,
	-- 		})
	-- 	end,
	-- },

	-- {
	-- 	"nvimtools/none-ls.nvim",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		local null_ls_status_ok, null_ls = pcall(require, "null-ls")
	--
	-- 		-- local should_register_eslint_d = function(utils)
	-- 		-- 	return utils.root_has_file({
	-- 		-- 		".eslintrc.js",
	-- 		-- 		".eslintrc.json",
	-- 		-- 		".eslintrc.yml",
	-- 		-- 		".eslintrc",
	-- 		-- 		".eslintrc.yaml",
	-- 		-- 	}) and not utils.root_has_file({ "biome.json" })
	-- 		-- end
	--
	-- 		local should_register_prettierd = function(utils)
	-- 			return not utils.root_has_file({ "biome.json" })
	-- 		end
	--
	-- 		if null_ls_status_ok then
	-- 			local b = null_ls.builtins
	--
	-- 			null_ls.setup({
	-- 				sources = {
	-- 					-- b.formatting.stylua,
	-- 					-- b.hover.dictionary,
	-- 					-- -- Go
	-- 					-- b.formatting.gofmt,
	-- 					-- Typescript
	-- 					-- b.formatting.biome.with({
	-- 					-- 	args = {
	-- 					-- 		"check",
	-- 					-- 		"--apply-unsafe",
	-- 					-- 		"--formatter-enabled=true",
	-- 					-- 		"--organize-imports-enabled=true",
	-- 					-- 		"--skip-errors",
	-- 					-- 		"$FILENAME",
	-- 					-- 	},
	-- 					-- 	condition = function(utils)
	-- 					-- 		return utils.root_has_file({ "biome.json" })
	-- 					-- 	end,
	-- 					-- }),
	-- 					-- b.formatting.prettierd.with({
	-- 					-- 	condition = should_register_prettierd,
	-- 					-- }),
	-- 					-- b.formatting.clang_format,
	-- 					-- b.diagnostics.eslint_d.with({
	-- 					-- 	condition = should_register_eslint_d,
	-- 					-- }),
	-- 					-- b.code_actions.eslint_d.with({
	-- 					-- 	condition = should_register_eslint_d,
	-- 					-- }),
	-- 				},
	-- 			})
	-- 		end
	-- 	end,
	-- },
	-- {
	--   -- Set lualine as statusline
	--   "nvim-lualine/lualine.nvim",
	--   event = "VeryLazy",
	--   dependencies = { "nvim-tree/nvim-web-devicons" },
	--   -- See `:help lualine.txt`
	--   config = function()
	--     require("lualine").setup({
	--       theme = "gruvbox",
	--       options = {
	--         icons_enabled = true,
	--         component_separators = "|",
	--         -- section_separators = { left = "", right = "" },
	--         -- section_separators = { left = "", right = "" },
	--       },
	--       globalstatus = false,
	--       sections = {
	--         lualine_a = {},
	--         lualine_b = {
	--           "diagnostics",
	--         },
	--         lualine_c = {
	--           {
	--             "filename",
	--             file_status = true, -- displays file status (readonly status, modified status)
	--             path = 1,    -- 0 = just filename, 1 = relative path, 2 = absolute path
	--           },
	--         },
	--         lualine_x = {},
	--         lualine_y = {
	--
	--           "diff",
	--         },
	--         lualine_z = { "branch" },
	--       },
	--     })
	--   end,
	-- },
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		ft = { "rust" },
	},
	{
		"elixir-tools/elixir-tools.nvim",
		ft = { "elixir" },
		version = "*",
		-- event = { "BufReadPre", "BufNewFile" },
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
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = { "h", "<leader>h", "m" },
		config = function()
			local harpoon = require("harpoon")

			-- REQUIRED
			harpoon:setup({
				global_settings = {
					save_on_toggle = true,
				},
			})
			-- REQUIRED

			vim.keymap.set("n", "<leader>h", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set("n", "m", function()
				harpoon:list():add()
			end)

			-- buffers
			vim.keymap.set("n", "ha", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "hr", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "hs", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "ht", function()
				harpoon:list():select(4)
			end)
			vim.keymap.set("n", "hg", function()
				harpoon:list():select(5)
			end)
		end,
	},
	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	event = "InsertEnter",
	-- 	config = function()
	-- 		require("copilot").setup({
	-- 			filetypes = {
	-- 				-- disable for cpp cause you're learning you bitch
	-- 				cpp = false,
	-- 			},
	-- 			suggestion = {
	-- 				enabled = true,
	-- 				auto_trigger = true,
	-- 				debounce = 50,
	-- 				keymap = {
	-- 					accept = "<tab>",
	-- 					accept_word = false,
	-- 					accept_line = false,
	-- 					next = "<M-]>",
	-- 					prev = "<M-[>",
	-- 				},
	-- 			},
	-- 			panel = { enabled = false },
	-- 		})
	-- 	end,
	-- },
	{
		"Wansmer/treesj",
		keys = { "<space>m", "<space>j", "<space>s" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup()
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cond = false,
		dependencies = { "aklt/plantuml-syntax" },
		ft = "markdown",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			local g = vim.g
			g.mkdp_auto_start = 1
			g.mkdp_auto_close = 1
			g.mkdp_page_title = "${name}.md"
			g.mkdp_preview_options = {
				disable_sync_scroll = 0,
				disable_filename = 1,
			}
		end,
	},
	-- Experimental stuff
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
		-- stylua: ignore
		keys = {
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
			{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
			{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
			{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
		},
	},
	-- {
	-- 	"folke/todo-comments.nvim",
	-- 	event = "VeryLazy",
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- 	opts = {
	-- 		-- your configuration comes here
	-- 		-- or leave it empty to use the default settings
	-- 		-- refer to the configuration section below
	-- 	},
	-- },
	-- { "eandrju/cellular-automaton.nvim" },
	--
	{
		"epwalsh/obsidian.nvim",
		cond = false,
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		-- ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		event = {
			-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
			-- refer to `:h file-pattern` for more examples
			"BufReadPre "
				.. vim.fn.expand("~")
				.. "/Documents/vaults/naluri/",
			"BufNewFile " .. vim.fn.expand("~") .. "/Documents/vaults/naluri/",
		},
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
			-- see below for full list of optional dependencies 👇
		},
		opts = {
			workspaces = {
				{
					name = "work",
					path = "~/Documents/vaults/naluri/",
				},
			},

			-- see below for full list of options 👇
		},
	},
}
