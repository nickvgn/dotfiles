return {
	-- Detect tabstop and shiftwidth automatically
	{
		"tpope/vim-sleuth",
		event = "BufEnter",
	},
	{
		"tpope/vim-fugitive",
		cmd = "Git",
		keys = { "<leader>g" },
		lazy = true,
		config = function()
			-- git keymaps
			vim.keymap.set("n", "<leader>g", "<cmd>Git<cr>", { noremap = true, silent = true })
			-- diffget keymaps
			vim.keymap.set("n", "<leader>da", "<cmd>diffget //2<cr>", { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>do", "<cmd>diffget //3<cr>", { noremap = true, silent = true })
		end,
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

	{
		"nvimtools/none-ls.nvim",
		event = "VeryLazy",
		config = function()
			local null_ls_status_ok, null_ls = pcall(require, "null-ls")

			-- local should_register_eslint_d = function(utils)
			-- 	return utils.root_has_file({
			-- 		".eslintrc.js",
			-- 		".eslintrc.json",
			-- 		".eslintrc.yml",
			-- 		".eslintrc",
			-- 		".eslintrc.yaml",
			-- 	}) and not utils.root_has_file({ "biome.json" })
			-- end

			local should_register_prettierd = function(utils)
				return not utils.root_has_file({ "biome.json" })
			end

			if null_ls_status_ok then
				local b = null_ls.builtins

				null_ls.setup({
					sources = {
						-- b.formatting.stylua,
						-- b.hover.dictionary,
						-- -- Go
						-- b.formatting.gofmt,
						-- Typescript
						-- b.formatting.biome.with({
						-- 	args = {
						-- 		"check",
						-- 		"--apply-unsafe",
						-- 		"--formatter-enabled=true",
						-- 		"--organize-imports-enabled=true",
						-- 		"--skip-errors",
						-- 		"$FILENAME",
						-- 	},
						-- 	condition = function(utils)
						-- 		return utils.root_has_file({ "biome.json" })
						-- 	end,
						-- }),
						-- b.formatting.prettierd.with({
						-- 	condition = should_register_prettierd,
						-- }),
						-- b.formatting.clang_format,
						-- b.diagnostics.eslint_d.with({
						-- 	condition = should_register_eslint_d,
						-- }),
						-- b.code_actions.eslint_d.with({
						-- 	condition = should_register_eslint_d,
						-- }),
					},
				})
			end
		end,
	},

	{
		-- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			-- nvim-cmp setup
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			require("cmp").setup({
				sources = {
					{ name = "nvim_lsp_signature_help" },
				},
			})

			luasnip.config.setup({})

			cmp.setup({
				experimental = {
					ghost_text = false,
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = false,
					}),
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
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}),
				window = {
					documentation = cmp.config.window.bordered(),
					completion = cmp.config.window.bordered({
						winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
					}),
				},
			})
		end,
	},
	{
		-- Adds git releated signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 500,
				ignore_whitespace = false,
			},
		},
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					-- Actions
					map("n", "<leader>gs", gs.stage_hunk)
					map("n", "<leader>gr", gs.reset_hunk)
					map("v", "<leader>gs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("v", "<leader>gr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("n", "<leader>gS", gs.stage_buffer)
					map("n", "<leader>gu", gs.undo_stage_hunk)
					map("n", "<leader>gR", gs.reset_buffer)
					map("n", "<leader>gp", gs.preview_hunk)
					map("n", "<leader>gb", function()
						gs.blame_line({ full = true })
					end)
					map("n", "<leader>tb", gs.toggle_current_line_blame)
					map("n", "<leader>gd", gs.diffthis)
					map("n", "<leader>gD", function()
						gs.diffthis("~")
					end)
					map("n", "<leader>td", gs.toggle_deleted)
					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			})
		end,
	},
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
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
			-- see `:help nvim-treesitter`

			-- indent level at which it folds
			vim.opt.foldlevel = 20
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

			require("nvim-treesitter.configs").setup({
				-- add languages to be installed here that you want installed for treesitter
				ensure_installed = { "cpp", "lua", "rust", "tsx", "typescript", "vim" },
				-- autoinstall languages that are not installed. defaults to false (but you can change for yourself!)
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

			-- Hurl
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.hurl = {
				install_info = {
					url = "~/git/github.com/kjuulh/tree-sitter-hurl",
					files = { "src/parser.c" },
					branch = "main",
					generate_requires_npm = false,
					requires_generate_from_grammar = false,
				},
				filetype = "hurl",
			}
			-- https://neovim.io/doc/user/lua.html#vim.filetype.add()
			-- Search for vim.filetype.add
			vim.filetype.add({
				extension = {
					hurl = "hurl",
				},
			})
		end,
	},
	-- {
	-- 	"simrat39/rust-tools.nvim",
	-- 	ft = "rust",
	-- 	config = function()
	-- 		local rt = require("rust-tools")
	--
	-- 		rt.setup({
	-- 			server = {
	-- 				on_attach = function(_, bufnr)
	-- 					-- Hover actions
	-- 					vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
	-- 					-- Code action groups
	-- 					vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
	-- 				end,
	-- 			},
	-- 		})
	-- 	end,
	-- },
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
	{
		"elixir-tools/elixir-tools.nvim",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
		filetypes = { "elixir" },
		config = function()
			local elixir = require("elixir")
			local elixirls = require("elixir.elixirls")

			elixir.setup({
				nextls = { enable = true },
				credo = {},
				elixirls = {
					enable = true,
					settings = elixirls.settings({
						dialyzerEnabled = false,
						enableTestLenses = false,
					}),
					on_attach = function(client, bufnr)
						vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
						vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
						vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
					end,
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
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				filetypes = {
					-- disable for cpp cause you're learning you bitch
					cpp = false,
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 50,
					keymap = {
						accept = "<tab>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
					},
				},
				panel = { enabled = false },
			})
		end,
	},
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
	{ -- Autoformat
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			-- format_on_save = function(bufnr)
			-- 	-- Disable "format_on_save lsp_fallback" for languages that don't
			-- 	-- have a well standardized coding style. You can add additional
			-- 	-- languages here or re-enable it for the disabled ones.
			-- 	local disable_filetypes = {
			-- 		c = true,
			-- 		cpp = true,
			-- 	}
			-- 	return {
			-- 		timeout_ms = 500,
			-- 		lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
			-- 	}
			-- end,
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "gofmt" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use a sub-list to tell conform to run *until* a formatter
				-- is found.
				javascript = { "biome-check" },
				typescript = { "biome-check" },
				typescriptreact = { "biome-check" },
			},
		},
	},
	-- Experimental stuff
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
}
