-- local bufnr = vim.api.nvim_get_current_buf()
--
-- local nmap = function(keys, func, desc)
-- 	if desc then
-- 		desc = "LSP: " .. desc
-- 	end
--
-- 	vim.keymap.set("n", keys, func, { silent = true, buffer = bufnr, desc = desc })
-- end
--
-- nmap("<leader>a", function()
-- 	print("Code [A]ction")
-- 	vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
-- 	-- or vim.lsp.buf.codeAction() if you don't want grouping.
-- end, "Code [A]ction")

-- NOTE: use this file for additional rustaceanvim lsp keymaps
--
vim.g.rustaceanvim = {
	tools = {
		float_win_config = {
			border = "rounded",
		},
	},
}
