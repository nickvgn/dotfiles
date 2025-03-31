return {
	{
		"justinmk/vim-dirvish",
		cmd = { "Dirvish" },
		config = function()
			vim.g.dirvish_mode = ":sort ,^.*[/], | silent keeppatterns g/\\.DS_Store$/d _"
		end,
	},
	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
	},
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
		end,
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
		"Wansmer/treesj",
		keys = { "<space>m", "<space>j", "<space>s" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup()
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
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
}
