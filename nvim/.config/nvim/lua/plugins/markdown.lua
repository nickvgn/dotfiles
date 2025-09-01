return {
	{
		"obsidian-nvim/obsidian.nvim",
		-- version = "*",
		lazy = true,
		cmd = { "Obsidian" },
		keys = { "<leader>o" },
		ft = "markdown",
		-- event = {
		-- 	-- Adjust to match your vault location(s), triggered when reading or creating markdown files:
		-- 	"BufReadPre "
		-- 		.. vim.fn.expand("~")
		-- 		.. obsidian_relative_path,
		-- 	"BufNewFile " .. vim.fn.expand("~") .. obsidian_relative_path,
		-- },
		dependencies = {
			"nvim-lua/plenary.nvim", -- required :contentReference[oaicite:0]{index=0}
			"ibhagwan/fzf-lua", -- optional picker replacement :contentReference[oaicite:1]{index=1}
			"saghen/blink.cmp",
		},
		---@module 'obsidian'
		---@type obsidian.config
		opts = {
			ui = { enable = false },
			workspaces = {
				{
					name = "personal",
					path = "~/Documents/vaults/personal",
				},
				{
					name = "ugroup",
					path = "~/Documents/vaults/ugroup",
				},
			},
			legacy_commands = false,
			completion = {
				blink = true,
				nvim_cmp = false,
				min_chars = 1,
			},
			-- you can add other options here per obsidian.nvim README
			templates = {
				folder = "templates", -- where your templates live
				-- ddd, D MMM YY
				date_format = "%a, %d %b %y",
			},
			daily_notes = {
				folder = "daily", -- where your daily notes live
				date_format = "%a, %d %b %y",
				template = "daily.md", -- name of template in /templates (optional)
			},
		},
		config = function(_, opts)
			require("obsidian").setup(opts)
			vim.keymap.set("n", "<leader>o", ":Obsidian<cr>", { noremap = true, silent = true })
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = "markdown",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			completions = { blink = { enabled = false } },
			sign = { enabled = false },
			heading = {
				-- Useful context to have when evaluating values.
				-- | level    | the number of '#' in the heading marker         |
				-- | sections | for each level how deeply nested the heading is |

				-- Turn on / off heading icon & background rendering.
				enabled = true,
				-- Additional modes to render headings.
				render_modes = false,
				-- Turn on / off atx heading rendering.
				atx = true,
				-- Turn on / off setext heading rendering.
				setext = true,
				-- Replaces '#+' of 'atx_h._marker'.
				-- Output is evaluated depending on the type.
				-- | function | `value(context)`              |
				-- | string[] | `cycle(value, context.level)` |
				-- icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
				icons = { "1️⃣  ", "2️⃣  ", "3️⃣  ", "4️⃣  ", "5️⃣  ", "6️⃣  " },
				-- Determines how icons fill the available space.
				-- | right   | '#'s are concealed and icon is appended to right side                      |
				-- | inline  | '#'s are concealed and icon is inlined on left side                        |
				-- | overlay | icon is left padded with spaces and inserted on left hiding additional '#' |
				position = "inline",
				-- Added to the sign column if enabled.
				-- Output is evaluated by `cycle(value, context.level)`.
				-- Width of the heading background.
				-- | block | width of the heading text |
				-- | full  | full width of the window  |
				-- Can also be a list of the above values evaluated by `clamp(value, context.level)`.
				width = "block",
				-- Amount of margin to add to the left of headings.
				-- Margin available space is computed after accounting for padding.
				-- If a float < 1 is provided it is treated as a percentage of available window space.
				-- Can also be a list of numbers evaluated by `clamp(value, context.level)`.
				left_margin = 0,
				-- Amount of padding to add to the left of headings.
				-- Output is evaluated using the same logic as 'left_margin'.
				left_pad = 2,
				-- Amount of padding to add to the right of headings when width is 'block'.
				-- Output is evaluated using the same logic as 'left_margin'.
				right_pad = 2,
				-- Minimum width to use for headings when width is 'block'.
				-- Can also be a list of integers evaluated by `clamp(value, context.level)`.
				min_width = 0,
				-- Determines if a border is added above and below headings.
				-- Can also be a list of booleans evaluated by `clamp(value, context.level)`.
				border = false,
				-- Always use virtual lines for heading borders instead of attempting to use empty lines.
				border_virtual = true,
				-- Highlight the start of the border using the foreground highlight.
				border_prefix = false,
				-- Define custom heading patterns which allow you to override various properties based on
				-- the contents of a heading.
				-- The key is for healthcheck and to allow users to change its values, value type below.
				-- | pattern    | matched against the heading text @see :h lua-patterns |
				-- | icon       | optional override for the icon                        |
				-- | background | optional override for the background                  |
				-- | foreground | optional override for the foreground                  |
				custom = {},
			},
			indent = {
				-- Mimic org-indent-mode behavior by indenting everything under a heading based on the
				-- level of the heading. Indenting starts from level 2 headings onward by default.

				-- Turn on / off org-indent-mode.
				enabled = true,
				-- Additional modes to render indents.
				render_modes = false,
				-- Amount of additional padding added for each heading level.
				per_level = 4,
				-- Heading levels <= this value will not be indented.
				-- Use 0 to begin indenting from the very first level.
				skip_level = 1,
				-- Do not indent heading titles, only the body.
				skip_heading = false,
				-- Prefix added when indenting, one per level.
				-- icon = "▎",
				icon = "",
				-- Priority to assign to extmarks.
				priority = 0,
				-- Applied to icon.
				highlight = "RenderMarkdownIndent",
			},
			code = {
				-- Turn on / off code block & inline code rendering.
				enabled = true,
				-- Additional modes to render code blocks.
				render_modes = false,
				-- Turn on / off sign column related rendering.
				sign = false,
				-- Whether to conceal nodes at the top and bottom of code blocks.
				conceal_delimiters = false,
				-- Turn on / off language heading related rendering.
				language = true,
				-- Determines where language icon is rendered.
				-- | right | right side of code block |
				-- | left  | left side of code block  |
				position = "left",
				-- Whether to include the language icon above code blocks.
				language_icon = true,
				-- Whether to include the language name above code blocks.
				language_name = true,
				-- Whether to include the language info above code blocks.
				language_info = true,
				-- Amount of padding to add around the language.
				-- If a float < 1 is provided it is treated as a percentage of available window space.
				language_pad = 0,
				-- A list of language names for which background highlighting will be disabled.
				-- Likely because that language has background highlights itself.
				-- Use a boolean to make behavior apply to all languages.
				-- Borders above & below blocks will continue to be rendered.
				disable_background = { "diff" },
				-- Width of the code block background.
				-- | block | width of the code block  |
				-- | full  | full width of the window |
				width = "block",
				-- Amount of margin to add to the left of code blocks.
				-- If a float < 1 is provided it is treated as a percentage of available window space.
				-- Margin available space is computed after accounting for padding.
				left_margin = 0,
				-- Amount of padding to add to the left of code blocks.
				-- If a float < 1 is provided it is treated as a percentage of available window space.
				left_pad = 0,
				-- Amount of padding to add to the right of code blocks when width is 'block'.
				-- If a float < 1 is provided it is treated as a percentage of available window space.
				right_pad = 0,
				-- Minimum width to use for code blocks when width is 'block'.
				min_width = 0,
				-- Determines how the top / bottom of code block are rendered.
				-- | none  | do not render a border                               |
				-- | thick | use the same highlight as the code body              |
				-- | thin  | when lines are empty overlay the above & below icons |
				-- | hide  | conceal lines unless language name or icon is added  |
				border = "thin",
				-- Used above code blocks to fill remaining space around language.
				language_border = "█",
				-- Added to the left of language.
				language_left = "",
				-- Added to the right of language.
				language_right = "",
				-- Used above code blocks for thin border.
				above = "▄",
				-- Used below code blocks for thin border.
				below = "▀",
				-- Turn on / off inline code related rendering.
				inline = true,
				-- Icon to add to the left of inline code.
				inline_left = "",
				-- Icon to add to the right of inline code.
				inline_right = "",
				-- Padding to add to the left & right of inline code.
				inline_pad = 0,
				-- Highlight for code blocks.
				highlight = "RenderMarkdownCode",
				-- Highlight for code info section, after the language.
				highlight_info = "RenderMarkdownCodeInfo",
				-- Highlight for language, overrides icon provider value.
				highlight_language = nil,
				-- Highlight for border, use false to add no highlight.
				highlight_border = "RenderMarkdownCodeBorder",
				-- Highlight for language, used if icon provider does not have a value.
				highlight_fallback = "RenderMarkdownCodeFallback",
				-- Highlight for inline code.
				highlight_inline = "RenderMarkdownCodeInline",
				-- Determines how code blocks & inline code are rendered.
				-- | none     | { enabled = false }                           |
				-- | normal   | { language = false }                          |
				-- | language | { disable_background = true, inline = false } |
				-- | full     | uses all default values                       |
				style = "full",
			},
		},
		config = function(_, opts)
			require("render-markdown").setup(opts)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function()
					vim.wo.colorcolumn = ""
				end,
			})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		dependencies = { "aklt/plantuml-syntax" },
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
