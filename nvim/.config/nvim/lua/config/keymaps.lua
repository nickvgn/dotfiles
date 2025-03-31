vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- for switching between terminal and vim splits
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
vim.keymap.set("n", "<Tab>", [[<C-w><C-w>]], { noremap = true, silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap for saving and quiting buffers
vim.keymap.set("n", "<Leader>w", "<cmd>w<CR>", { noremap = true })
vim.keymap.set("n", "<Leader>wq", "<cmd>wq<CR>", { noremap = true })
vim.keymap.set("n", "<Leader>x", "<cmd>q<CR>", { noremap = true })

vim.keymap.set("n", "<space>ft", ":Dirvish<cr>", { noremap = true, desc = "[F]ile [T]ree", silent = true })

local function remove_quickfix_item()
	local qf_list = vim.fn.getqflist()

	local qf_info = vim.fn.getqflist({ idx = 0 })
	local current_idx = qf_info.idx

	-- If the list is not empty and there is a valid index
	if current_idx > 0 and current_idx <= #qf_list then
		-- Remove the current entry from the quickfix list
		table.remove(qf_list, current_idx)

		-- Update the quickfix list with the modified list
		vim.fn.setqflist(qf_list, "r")

		-- Set the quickfix list to the next item, or the previous if the last item was removed
		local next_idx = math.min(current_idx, #qf_list) -- Ensure we don't exceed the list size
		if next_idx > 0 then
			vim.fn.setqflist({}, "r", { idx = next_idx })

			-- Jump to the next quickfix item (changes the code buffer)
			vim.cmd("cc") -- This is like typing :cc to jump to the current quickfix entry
		end
	end
end

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>dq", remove_quickfix_item, { noremap = true, silent = true })
