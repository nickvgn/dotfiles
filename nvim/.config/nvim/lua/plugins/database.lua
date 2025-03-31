return {
	{
		"kristijanhusak/vim-dadbod-ui",
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 0
			vim.g.db_ui_force_echo_notifications = 1
		end,
	},
}
