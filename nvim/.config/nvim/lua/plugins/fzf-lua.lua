return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "echasnovski/mini.icons" },
		opts = {},
		config = function()
			require("fzf-lua").setup({ "max-perf", fzf_colors = true })
			require("fzf-lua").register_ui_select()
			vim.keymap.set("n", "<leader><space>", require("fzf-lua").files, { desc = "[ ] Find files" })
			vim.keymap.set("n", "<leader>sb", require("fzf-lua").buffers, { desc = "[S]earch [B]uffers" })
			vim.keymap.set("n", "<leader>of", require("fzf-lua").oldfiles, { desc = "Search [O]ld [F]iles" })
			vim.keymap.set("n", "<leader>sg", require("fzf-lua").live_grep_native, { desc = "[S]earch by [G]rep" })
			vim.keymap.set(
				"n",
				"<leader>sd",
				require("fzf-lua").diagnostics_workspace,
				{ desc = "[S]earch [D]iagnostics" }
			)
			vim.keymap.set("n", "<leader>gb", require("fzf-lua").git_branches, { desc = "[G]it [B]ranches" })
		end,
	},
}

-- NOTE: you used to ignore these with telescope

-- 	"node_modules",
-- 	".git",
-- 	".cache",
-- 	"vendor",
-- 	"Pods",
-- 	-- "android",
-- 	".yarn",
-- 	".bundle",
-- 	".DS_Store",
-- 	-- all images
-- 	-- ".png",
-- 	-- ".jpg",
-- 	-- ".jpeg",
-- 	-- ".gif",
-- 	-- ".webp",
-- 	-- ".svg",
-- 	-- fonts
-- 	".ttf",
-- 	".otf",
-- 	-- bun lock file
-- 	".lockb"
