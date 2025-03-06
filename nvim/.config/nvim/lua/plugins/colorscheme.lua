return {
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
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				transparent_mode = true,
				contrast = "hard",
			})
			vim.cmd("colorscheme gruvbox")
		end,
	},
	-- ayu
	-- {
	-- 	"ayu-theme/ayu-vim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.g.ayucolor = "dark"
	-- 		vim.cmd("colorscheme ayu")
	-- 	end,
	-- }
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
	-- {
	-- 	"neanias/everforest-nvim",
	-- 	version = false,
	-- 	lazy = false,
	-- 	priority = 1000, -- make sure to load this before all the other start plugins
	-- 	-- Optional; default configuration will be used if setup isn't called.
	-- 	config = function()
	-- 		require("everforest").setup({
	-- 			-- Your config here
	-- 			background = "hard",
	-- 			transparent_background_level = 1,
	-- 			italics = true,
	-- 			disable_italic_comments = true,
	-- 			on_highlights = function(hl, _)
	-- 				hl["@string.special.symbol.ruby"] = { link = "@field" }
	-- 			end,
	-- 		})
	-- 		vim.cmd("colorscheme everforest")
	-- 	end,
	-- },
	-- {
	-- 	"RRethy/base16-nvim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd.colorscheme("base16-tomorrow-night")
	-- 	end,
	-- },
	-- {
	-- 	"tinted-theming/tinted-vim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.g.tinted_background_transparent = 1
	-- 		vim.cmd.colorscheme("base16-chalk")
	-- 	end,
	-- },
}
