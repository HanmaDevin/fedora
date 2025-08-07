return {
  vim.keymap.set('n', '<leader>tc', ':CopilotChatToggle<CR>', { desc = 'Toggle Copilot Chat' }),
  vim.keymap.set('n', '<leader>lg', ':LazyGit<CR>', { desc = 'LazyGit' }),
  vim.keymap.set('n', '<leader>bd', ':bd<CR>', { desc = 'Delete Buffer' }),
  vim.keymap.set('n', '<leader>md', ':MarkdownPreviewToggle<CR>', { desc = 'Preview markdown in Browser' }),
  vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { desc = 'Save file' }),
  vim.keymap.set('n', '<C-s>', '<Esc>:w<CR>', { desc = 'Save file' }),
  vim.keymap.set('n', '<leader>dc', ':Copilot disable<CR>', { desc = 'Disable Copilot' }),
}
