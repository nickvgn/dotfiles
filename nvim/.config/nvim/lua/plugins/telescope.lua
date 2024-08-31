-- Fuzzy Finder (files, lsp, etc)
return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
		},
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
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
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
						-- all images
						".png",
						".jpg",
						".jpeg",
						".gif",
						".webp",
						".svg",
						-- fonts
						".ttf",
						".otf",
						-- bun lock file
						".lockb",
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

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
			vim.keymap.set("n", "<leader>gb", require("telescope.builtin").git_branches, { desc = "[G]it [B]ranches" })
		end,
	},
}
