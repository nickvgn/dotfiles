vim.lsp.enable({ 'gopls', 'luals', 'ts_ls', 'biome', 'tailwindcss' })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    map("gr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")
    map("<leader>ds", require("fzf-lua").lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>ws", require("fzf-lua").lsp_live_workspace_symbols, "[W]orkspace [S]ymbols")
    map("<leader>cl", vim.lsp.codelens.run, "[C]ode[L]ens")

    map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    map("<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- Diagnostic

local function jump_back()
  vim.diagnostic.jump({ count = -1, float = false })
end
local function jump_forward()
  vim.diagnostic.jump({ count = 1, float = false })
end

-- Diagnostic keymaps
vim.keymap.set("n", "[d", jump_back, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", jump_forward, { desc = "Go to next diagnostic message" })

vim.diagnostic.config({
  virtual_lines = {
    source           = 'if_many',
    current_line     = true,
    severity_sort    = true,
    update_in_insert = true
  },
  float = {
    source = 'if_many',
    border = "rounded",
    scope  = "cursor"
  },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
})

vim.g.rustaceanvim = {
  tools = {
    float_win_config = {
      border = "rounded",
    },
  },
}
