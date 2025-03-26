--  NOTE: Explore or search through `:help lua-guide`

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("config.lazy")

vim.loader.enable({ enable = true })

-- [[ Setting options ]]
-- See `:help vim.o`
--vim.keymap.set("n", "<leader>cp", "<cmd>Copilot<cr>", { noremap = true, silent = true })
vim.o.list = true
-- vim.o.listchars = "trail:·,eol:¬,tab:|"
vim.o.listchars = "trail:·,eol:¬,tab:  "
-- show character at word wrap
vim.o.showbreak = "↪ "
-- Set highlight on search
vim.o.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")
-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true
-- Enable mouse mode
vim.o.mouse = "a"
-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = "unnamedplus"
-- vim.g.clipboard = { name = "pbcoby", cache_enabled = true }
--     ↑ clipboard provider
-- Enable break indent
vim.o.breakindent = true
vim.opt.smartindent = true
vim.opt.autoindent = true
-- Save undo history
vim.o.undofile = true
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"
vim.wo.colorcolumn = "100"
-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300
-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"
-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.inccommand = "split"
-- disable swap files
vim.opt.swapfile = false
-- turn off neovim intro
-- vim.o.shortmess = vim.o.shortmess .. "I"

vim.o.termsync = false

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2

vim.opt.pumblend = 0 -- for cmp menu
vim.opt.winblend = 0 -- for documentation popup

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0

-- project local vim config
vim.o.exrc = true

-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
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

vim.keymap.set("n", "<space>ft", ":Explore<cr>", { noremap = true, desc = "[F]ile [T]ree" })

-- Hide .DS_Store files in Netrw
-- images (webp, png, jpg, jpeg, gif, bmp, tiff, svg)
vim.g.netrw_list_hide = ".*.DS_Store"

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { noremap = true, silent = true })

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

vim.keymap.set("n", "<leader>dq", remove_quickfix_item, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { noremap = true, silent = true })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
