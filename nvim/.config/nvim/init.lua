--  NOTE: Explore or search through `:help lua-guide`

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.have_nerd_font = false

vim.loader.enable(true)

require("config.lazy")
require("config.options")
require('config.keymaps')
require('config.autocmd')
require('config.lsp')
