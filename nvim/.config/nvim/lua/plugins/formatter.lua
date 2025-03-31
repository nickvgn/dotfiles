return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
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
		-- This will provide type hinting with LuaLS
		---@module "conform"
		---@type conform.setupOpts
		opts = {
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
				python = {
					-- To fix auto-fixable lint errors.
					"ruff_fix",
					-- To run the Ruff formatter.
					"ruff_format",
					-- To organize the imports.
					"ruff_organize_imports",
				},
				--
				-- You can use a sub-list to tell conform to run *until* a formatter
				-- is found.
				javascript = { "biome-check", "prettierd" },
				javascriptreact = { "biome-check", "prettierd" },
				typescript = { "biome-check", "prettierd" },
				typescriptreact = { "biome-check", "prettierd" },
				json = { "biome-check", "prettierd" },
				jsonc = { "biome-check", "prettierd" },
				elixir = { "mix_format" },
			},
			-- Set this to change the default values when calling conform.format()
			-- This will also affect the default values for format_on_save/format_after_save
			-- default_format_opts = {
			-- 	lsp_format = "fallback",
			-- },
			-- If this is set, Conform will run the formatter on save.
			-- It will pass the table to conform.format().
			-- This can also be a function that returns the table.
			-- format_on_save = {
			-- 	-- I recommend these options. See :help conform.format for details.
			-- 	lsp_format = "fallback",
			-- 	timeout_ms = 500,
			-- },
			-- If this is set, Conform will run the formatter asynchronously after save.
			-- It will pass the table to conform.format().
			-- This can also be a function that returns the table.
			-- format_after_save = {
			-- 	lsp_format = "fallback",
			-- },
			-- Set the log level. Use `:ConformInfo` to see the location of the log file.
			log_level = vim.log.levels.ERROR,
			-- Conform will notify you when a formatter errors
			notify_on_error = true,
			-- Conform will notify you when no formatters are available for the buffer
			notify_no_formatters = true,
			-- Custom formatters and overrides for built-in formatters
		},
	},
}
