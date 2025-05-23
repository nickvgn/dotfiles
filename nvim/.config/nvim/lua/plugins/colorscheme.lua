return {
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		branch = "main",
		config = function()
			require("gruvbox").setup({
				transparent_mode = true,
				contrast = "hard",
				overrides = {
					StatusLine = { fg = "#a89984", bg = "#282828" },
					StatusLineNC = { fg = "#a89984", bg = "#282828" },
					ColorColumn = { bg = "#282828" },
				},
			})
			vim.cmd("colorscheme gruvbox")
		end,
	},
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("catppuccin").setup({
	-- 			flavour = "mocha", -- latte, frappe, macchiato, mocha
	-- 			transparent_background = true, -- disables setting the background color.
	-- 			show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
	-- 			dim_inactive = {
	-- 				enabled = true, -- dims the background color of inactive window
	-- 				shade = "dark",
	-- 				percentage = 0.15, -- percentage of the shade to apply to the inactive window
	-- 			},
	-- 			styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
	-- 				comments = { "italic" }, -- Change the style of comments
	-- 				conditionals = { "italic" },
	-- 				loops = {},
	-- 				functions = {},
	-- 				keywords = {},
	-- 				strings = {},
	-- 				variables = {},
	-- 				numbers = {},
	-- 				booleans = {},
	-- 				properties = {},
	-- 				types = {},
	-- 				operators = {},
	-- 			},
	-- 			color_overrides = {},
	-- 			custom_highlights = {},
	-- 		})
	--
	-- 		vim.cmd.colorscheme("catppuccin")
	-- 	end,
	-- },
	-- {
	-- 	"sainnhe/everforest",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.g.everforest_background = "hard"
	-- 		vim.g.everforest_ui_contrast = "high"
	-- 		vim.g.everforest_better_performance = 1
	-- 		vim.g.everforest_enable_italic = 1
	-- 		vim.g.everforest_transparent_background = 1
	-- 		vim.g.everforest_dim_inactive_windows = 1
	-- 		-- vim.g.everforest_diagnostic_text_highlight = 1
	-- 		-- vim.g.everforest_diagnostic_line_highlight = 1
	-- 		vim.g.everforest_diagnostic_virtual_text = "colored"
	-- 		vim.g.everforest_disable_terminal_colors = 1
	-- 		vim.cmd("colorscheme everforest")
	--
	-- 		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "floatBorder", { bg = "none" })
	-- 	end,
	-- },
}
