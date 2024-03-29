--  NOTE: Explore or search through `:help lua-guide`

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				transparent_mode = false,
				contrast = "hard",
			})
			vim.cmd("colorscheme gruvbox")
		end,
	},
	-- Detect tabstop and shiftwidth automatically
	{
		"tpope/vim-sleuth",
		lazy = true,
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
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ "williamboman/mason.nvim", build = ":MasonUpdate" },
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{
				"j-hui/fidget.nvim",
				event = "VeryLazy",
				tag = "legacy",
				opts = {
					text = {
						spinner = "arc",
						completed = "", -- message shown when task completes
					},
					align = {
						bottom = false, -- align fidgets along bottom edge of buffer
						right = true, -- align fidgets along right edge of buffer
					},
					timer = {
						spinner_rate = 125, -- frame rate of spinner animation, in ms
						fidget_decay = 1000, -- how long to keep around empty fidget, in ms
						task_decay = 800, -- how long to keep around completed task, in ms
					},
					window = {
						relative = "editor", -- where to anchor, either "win" or "editor"
						blend = 0, -- &winblend for the window
						zindex = nil, -- the zindex value for the window
						border = "none", -- style of border for the fidget window
					},
				},
			},
		},
		config = function()
			-- LSP settings.
			--  This function gets run when an LSP connects to a particular buffer.
			local on_attach = function(_, bufnr)
				local nmap = function(keys, func, desc)
					if desc then
						desc = "LSP: " .. desc
					end

					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
				end

				nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				nmap("<leader>a", vim.lsp.buf.code_action, "Code [A]ction")

				nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
				nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
				nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

				-- See `:help K` for why this keymap
				nmap("K", vim.lsp.buf.hover, "Hover Documentation")
				nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

				-- Lesser used LSP functionality
				nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
				nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
				nmap("<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, "[W]orkspace [L]ist Folders")

				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
					vim.lsp.buf.format()
				end, { desc = "Format current buffer with LSP" })
			end

			-- Enable the following language servers
			--  Add any additional override configuration in the following tables. They will be passed to
			--  the `settings` field of the server config. You must look up that documentation yourself.
			local servers = {
				clangd = {},
				tsserver = {},
				graphql = {},
				pyright = {},
				tailwindcss = {},
				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			}

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- Setup mason so it can manage external tooling
			require("mason").setup()

			-- Ensure the servers above are installed
			local mason_lspconfig = require("mason-lspconfig")

			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			mason_lspconfig.setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
					})
				end,
			})

			require("lspconfig.autoformat").setup()
			-- This will find your Git repository root and start the tsserver there.
			-- Otherwise, for some inexplicable reason, it appears to start this server in the current user’s home folder.
			require("lspconfig").tsserver.setup({
				root_dir = require("lspconfig.util").root_pattern(".git"),
			})
			require("lspconfig").graphql.setup({
				root_dir = require("lspconfig.util").root_pattern(".git"),
			})
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
		"jose-elias-alvarez/null-ls.nvim",
		event = "VeryLazy",
		config = function()
			local null_ls_status_ok, null_ls = pcall(require, "null-ls")

			local should_register_eslint_d = function(utils)
				return utils.root_has_file({
					".eslintrc.js",
					".eslintrc.json",
					".eslintrc.yml",
					".eslintrc",
					".eslintrc.yaml",
				})
			end

			if null_ls_status_ok then
				local b = null_ls.builtins

				null_ls.setup({
					sources = {
						b.formatting.stylua,
						b.hover.dictionary,
						-- Typescript
						b.formatting.prettierd,
						b.diagnostics.eslint_d.with({
							condition = should_register_eslint_d,
						}),
						b.code_actions.eslint_d.with({
							condition = should_register_eslint_d,
						}),
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
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			-- nvim-cmp setup
			local cmp = require("cmp")
			local luasnip = require("luasnip")
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
					{ name = "neorg" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}),
			})
		end,
	},
	-- {
	--   -- Adds git releated signs to the gutter, as well as utilities for managing changes
	--   "lewis6991/gitsigns.nvim",
	--   event = "VeryLazy",
	--   opts = {
	--     -- See `:help gitsigns.txt`
	--     signs = {
	--       add = { text = "+" },
	--       change = { text = "~" },
	--       delete = { text = "_" },
	--       topdelete = { text = "‾" },
	--       changedelete = { text = "~" },
	--     },
	--     current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	--     current_line_blame_opts = {
	--       virt_text = true,
	--       virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
	--       delay = 500,
	--       ignore_whitespace = false,
	--     },
	--   },
	--     config = function()
	--       require("gitsigns").setup({
	--         on_attach = function(bufnr)
	--           local gs = package.loaded.gitsigns
	--
	--           local function map(mode, l, r, opts)
	--             opts = opts or {}
	--             opts.buffer = bufnr
	--             vim.keymap.set(mode, l, r, opts)
	--           end
	--
	--           -- Navigation
	--           map("n", "]c", function()
	--             if vim.wo.diff then
	--               return "]c"
	--             end
	--             vim.schedule(function()
	--               gs.next_hunk()
	--             end)
	--             return "<Ignore>"
	--           end, { expr = true })
	--
	--           map("n", "[c", function()
	--             if vim.wo.diff then
	--               return "[c"
	--             end
	--             vim.schedule(function()
	--               gs.prev_hunk()
	--             end)
	--             return "<Ignore>"
	--           end, { expr = true })
	--
	--           -- Actions
	--           map("n", "<leader>gs", gs.stage_hunk)
	--           map("n", "<leader>gr", gs.reset_hunk)
	--           map("v", "<leader>gs", function()
	--             gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	--           end)
	--           map("v", "<leader>gr", function()
	--             gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
	--           end)
	--           map("n", "<leader>gS", gs.stage_buffer)
	--           map("n", "<leader>gu", gs.undo_stage_hunk)
	--           map("n", "<leader>gR", gs.reset_buffer)
	--           map("n", "<leader>gp", gs.preview_hunk)
	--           map("n", "<leader>gb", function()
	--             gs.blame_line({ full = true })
	--           end)
	--           map("n", "<leader>tb", gs.toggle_current_line_blame)
	--           map("n", "<leader>gd", gs.diffthis)
	--           map("n", "<leader>gD", function()
	--             gs.diffthis("~")
	--           end)
	--           map("n", "<leader>td", gs.toggle_deleted)
	--           -- Text object
	--           map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	--         end,
	--       })
	--     end,
	--   },
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
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o",               function() require("flash").remote() end,     desc = "Remote Flash" },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc =
        "Treesitter Search"
      },
      {
        "<c-s>",
        mode = { "c" },
        function() require("flash").toggle() end,
        desc =
        "Toggle Flash Search"
      },
    },
	},
	-- "gc" to comment visual regions/lines
	{
		"numToStr/Comment.nvim",
		lazy = true,
		event = "BufRead",
		config = function()
			require("Comment").setup({
				opleader = {
					line = "gc",
					block = "gb",
				},
			})
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "VeryLazy",
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
		config = function()
			require("nvim-treesitter.configs").setup({
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
			})
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},
	{
		"nvim-neorg/neorg",
		cmd = "Neorg",
		keys = { "<leader>n" },
		ft = "norg",
		build = ":Neorg sync-parsers",
		dependencies = { { "nvim-lua/plenary.nvim" }, "nvim-cmp" },
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {}, -- Loads default behaviour
					["core.concealer"] = {}, -- Adds pretty icons to your documents
					["core.dirman"] = { -- Manages Neorg workspaces
						config = {
							workspaces = {
								notes = "~/notes",
							},
							default_workspace = "notes",
						},
					},
				},
			})

			vim.keymap.set("n", "<space>ni", ":Neorg index<cr>", { noremap = true, desc = "[N]eorg [I]ndex" })
			vim.keymap.set("n", "<space>nr", ":Neorg return<cr>", { noremap = true, desc = "[N]eorg [R]eturn" })
		end,
	},

	-- Fuzzy Finder (files, lsp, etc)
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		version = "*",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			-- See `:help telescope` and `:help telescope.setup()`
			require("telescope").setup({
				pickers = {
					find_files = {
						hidden = true,
					},
					buffers = {
						show_all_buffers = true,
						sort_mru = true,
						mappings = {
							i = {
								["<c-d>"] = "delete_buffer",
							},
						},
					},
				},
				defaults = {
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-d>"] = false,
						},
					},
					-- custom ignore patterns
					file_ignore_patterns = {
						"node_modules",
						".git",
						".cache",
						"vendor",
						"Pods",
						-- "android",
						".yarn",
						".bundle",
						".DS_Store",
					},
				},
			})

			-- Enable telescope fzf native, if installed
			pcall(require("telescope").load_extension, "fzf")

			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 0,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			vim.keymap.set("n", "<leader><space>", require("telescope.builtin").find_files, { desc = "[ ] Find files" })
			vim.keymap.set("n", "<leader>sb", require("telescope.builtin").buffers, { desc = "[S]earch [B]uffers" })
			vim.keymap.set("n", "<leader>of", require("telescope.builtin").oldfiles, { desc = "Search [O]ld [F]iles" })
			vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set(
				"n",
				"<leader>sw",
				require("telescope.builtin").grep_string,
				{ desc = "[S]earch current [W]ord" }
			)
			vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set(
				"n",
				"<leader>sd",
				require("telescope.builtin").diagnostics,
				{ desc = "[S]earch [D]iagnostics" }
			)
		end,
	},

	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requireqments installed.
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		lazy = true,
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
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
			-- See `:help nvim-treesitter`

			-- indent level at which it folds
			vim.opt.foldlevel = 20
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

			require("nvim-treesitter.configs").setup({
				-- Add languages to be installed here that you want installed for treesitter
				ensure_installed = { "cpp", "lua", "rust", "tsx", "typescript", "vim" },
				-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
				auto_install = false,
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<M-space>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
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
							["]N"] = "@class.outer",
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
							["<leader>A"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},
	{
		"simrat39/rust-tools.nvim",
		ft = "rust",
		config = function()
			local rt = require("rust-tools")

			rt.setup({
				server = {
					on_attach = function(_, bufnr)
						-- Hover actions
						vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
						-- Code action groups
						vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
					end,
				},
			})
		end,
	},
	{
		"ThePrimeagen/harpoon",
		keys = { "h", "<leader>h" },
		config = function()
			vim.keymap.set("n", "<leader>h", function()
				require("harpoon.ui").toggle_quick_menu()
			end, { noremap = true })

			vim.keymap.set("n", "m", function()
				require("harpoon.mark").add_file()
			end, { noremap = true })

			-- terminal
			vim.keymap.set("n", "hg", function()
				require("harpoon.term").gotoTerminal(1)
			end, { noremap = true })

			-- buffers
			vim.keymap.set("n", "ha", function()
				require("harpoon.ui").nav_file(1)
			end, { noremap = true })
			vim.keymap.set("n", "hr", function()
				require("harpoon.ui").nav_file(2)
			end, { noremap = true })
			vim.keymap.set("n", "hs", function()
				require("harpoon.ui").nav_file(3)
			end, { noremap = true })
			-- terminal 1
			vim.keymap.set("n", "ht", function()
				require("harpoon.ui").nav_file(4)
			end, { noremap = true })
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
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
			if vim.fn.expand("$HOME") == "/Users/naluri-nick" then
				vim.g.copilot_node_command = vim.fn.expand("$HOME") .. "/.asdf/installs/nodejs/20.5.0/bin/node"
			end
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
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
--vim.keymap.set("n", "<leader>cp", "<cmd>Copilot<cr>", { noremap = true, silent = true })
vim.o.list = true
vim.o.listchars = "trail:·,eol:↴,tab:  "
-- show character at word wrap
vim.o.showbreak = "↪ "
-- Set highlight on search
vim.o.hlsearch = false
-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true
-- Enable mouse mode
vim.o.mouse = "a"
-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"
-- Enable break indent
vim.o.breakindent = true
vim.opt.smartindent = true
vim.opt.autoindent = true
-- Save undo history
vim.o.undofile = true
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"
vim.wo.colorcolumn = "100"
-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300
-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"
-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
-- disable swap files
vim.opt.swapfile = false
-- turn off neovim intro
vim.o.shortmess = vim.o.shortmess .. "I"

-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- for switching between terminal and vim splits
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
vim.keymap.set("n", "<Tab>", [[<C-w><C-w>]], { noremap = true, silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap for saving and quiting buffers
vim.keymap.set("n", "<Leader>w", "<cmd>w<CR>", { noremap = true })
vim.keymap.set("n", "<Leader>wq", "<cmd>wq<CR>", { noremap = true })
vim.keymap.set("n", "<Leader>x", "<cmd>q<CR>", { noremap = true })

vim.keymap.set("n", "<space>ft", ":Explore<cr>", { noremap = true, desc = "[F]ile [T]ree" })

-- Disable line number for terminal sessions in neovim
local neovim_terminal = vim.api.nvim_create_augroup("Terminal", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.api.nvim_command("setlocal nonumber norelativenumber signcolumn=no")
	end,
	group = neovim_terminal,
	pattern = "*",
})

-- Open Netrw automatically when starting Neovim in a directory without a file
vim.cmd("autocmd StdinReadPre * let s:std_in=1")
vim.cmd('autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | :Explore | endif')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
