return {
	{
		"ibhagwan/fzf-lua",
		keys = {
			"<leader><space>",
			"<leader>sb",
			"<leader>of",
			"<leader>sg",
			"<leader>sd",
			"<leader>gb",
		},
		opts = {},
		config = function()
			local actions = require("fzf-lua").actions
			require("fzf-lua").setup({
				"max-perf",
				fzf_colors = false, -- because we're setting it globally on fzf; see config.fish
				previewers = {
					codeaction_native = {
						diff_opts = { ctxlen = 3 },
						-- git-delta is automatically detected as pager, set `pager=false`
						-- to disable, can also be set under 'lsp.code_actions.preview_pager'
						-- recommended styling for delta
						pager = [[delta --width=$COLUMNS --hunk-header-style="omit" --file-style="omit"]],
					},
				},
				files = {
					lsp = {
						code_actions = {
							prompt = "Code Actions> ",
							async_or_timeout = 5000,
							-- when git-delta is installed use "codeaction_native" for beautiful diffs
							-- try it out with `:FzfLua lsp_code_actions previewer=codeaction_native`
							-- scroll up to `previewers.codeaction{_native}` for more previewer options
							previewer = "codeaction_native",
						},
					},
				},
			})
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
			vim.keymap.set("n", "<leader>bb", require("fzf-lua").git_branches, { desc = "[B]ranches" })
		end,
	},
}
