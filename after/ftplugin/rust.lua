local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
  "n",
  "<leader>a",
  function()
    -- vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    vim.lsp.buf.codeAction()
  end,
  { silent = true, buffer = bufnr }
)
vim.keymap.set(
  "n",
  "K",  -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
  function()
    vim.cmd.RustLsp({'hover', 'actions'})
  end,
  { silent = true, buffer = bufnr }
)

-- Rustaceanvim specific keymaps
vim.keymap.set('n', '<leader>rr', '<cmd>RustLsp runnables<CR>', { desc = 'Rust: Runnables' })
vim.keymap.set('n', '<leader>rd', '<cmd>RustLsp debuggables<CR>', { desc = 'Rust: Debuggables' })
