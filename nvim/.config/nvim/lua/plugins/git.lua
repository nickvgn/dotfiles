return {
	-- {
	-- 	"NeogitOrg/neogit",
	-- 	keys = { "<leader>g" },
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim", -- required
	-- 		"sindrets/diffview.nvim", -- optional - Diff integration
	-- 		"ibhagwan/fzf-lua", -- optional
	-- 	},
	-- 	config = function()
	-- 		local neogit = require("neogit")
	--
	-- 		vim.keymap.set("n", "<leader>g", neogit.open, { noremap = true, silent = true })
	--
	-- 		neogit.setup({
	-- 			disable_hint = true,
	-- 			kind = "replace",
	-- 		})
	-- 	end,
	-- },
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
}
