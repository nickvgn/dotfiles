vim.o.list = true
vim.o.listchars = "trail:·,eol:¬,tab:  "
-- show character at word wrap
vim.o.showbreak = "↪ "
-- Set highlight on search
vim.o.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")
-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false
-- Enable/Disable mouse mode
vim.o.mouse = ""
-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
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
vim.wo.signcolumn = "no"
vim.wo.colorcolumn = "100"
-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300
-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"
-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.confirm = true
vim.opt.inccommand = "split"
-- Show which line your cursor is on
vim.opt.cursorline = true
-- disable swap files
vim.opt.swapfile = false
-- turn off neovim intro
-- vim.o.shortmess = vim.o.shortmess .. "I"

vim.o.splitright = true
vim.o.termsync = false

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2

vim.opt.pumblend = 0 -- for cmp menu
vim.opt.winblend = 0 -- for documentation popup
vim.o.winborder = 'rounded'

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0

-- project local vim config
-- vim.o.exrc = true
