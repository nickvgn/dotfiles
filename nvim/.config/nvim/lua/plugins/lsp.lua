return {
	-- LSP Configuration & Plugins
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{ "williamboman/mason.nvim", lazy = true },
		{ "williamboman/mason-lspconfig.nvim", lazy = true },
		{ "WhoIsSethDaniel/mason-tool-installer.nvim", lazy = true },

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
					bottom = true, -- align fidgets along bottom edge of buffer
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
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local nmap = function(keys, func, desc)
					if desc then
						desc = "LSP: " .. desc
					end

					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
				end

				nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

				nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
				nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
				nmap("gr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")
				nmap("<leader>ds", require("fzf-lua").lsp_document_symbols, "[D]ocument [S]ymbols")
				nmap("<leader>ws", require("fzf-lua").lsp_live_workspace_symbols, "[W]orkspace [S]ymbols")

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

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end,
		})

		-- Enable the following language servers
		--  Add any additional override configuration in the following tables. They will be passed to
		--  the `settings` field of the server config. You must look up that documentation yourself.
		local servers = {
			gopls = {},
			clangd = {
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
			},
			tsserver = {},
			biome = {},
			ruff = {
				init_options = {
					settings = {
						-- Any extra CLI arguments for `ruff` go here.
						args = {},
					},
				},
			},
			pyright = {
				settings = {
					pyright = {
						-- Using Ruff's import organizer
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							-- Ignore all files for analysis to exclusively use Ruff for linting
							ignore = { "*" },
						},
					},
				},
			},
			graphql = {},
			-- pyright = {},
			tailwindcss = {
				settings = {
					tailwindCSS = {
						classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
						experimental = {
							classRegex = { { 'class[:]\\s*"([^"]*)"', 1 }, { '~H"([^"]*)"', 1 } },
						},
						includeLanguages = {
							eelixir = "html-eex",
							elixir = "html-eex",
							heex = "html-eex",
							html_eex = "html-eex",
							templ = "html",
						},
					},
				},
			},
			lua_ls = {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
						-- diagnostics = { disable = { 'missing-fields' } },
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			},
		}

		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		-- local capabilities = vim.lsp.protocol.make_client_capabilities()
		-- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Setup mason so it can manage external tooling
		require("mason").setup()

		-- Ensure the servers above are installed
		local mason_lspconfig = require("mason-lspconfig")

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		mason_lspconfig.setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for tsserver)
					if server_name == "tsserver" then
						server.on_attach = function(client)
							client.server_capabilities.documentFormattingProvider = false
							client.server_capabilities.documentRangeFormattingProvider = false
							if client.name == "ruff_lsp" then
								-- Disable hover in favor of Pyright
								client.server_capabilities.hoverProvider = false
							end
						end
					end
					server.capabilities = require("blink.cmp").get_lsp_capabilities()
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})

		vim.lsp.inlay_hint.enable()

		-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
		})
		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "rounded",
		})
		-- diagnostics window
		vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			virtual_text = {
				spacing = 2,
			},
			signs = true,
			underline = true,
			update_in_insert = true,
			pcall,
		})
		vim.diagnostic.config({
			float = { border = "rounded" },
		})

		vim.g.rustaceanvim = {
			tools = {
				float_win_config = {
					border = "rounded",
				},
			},
		}
	end,
}
