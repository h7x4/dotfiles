-- vim.cmd([[nnoremap <silent> <leader> :WhichKey '<Space>'<CR>]])
vim.api.nvim_set_keymap('n', '<space>', ':WhichKey <Space>', { noremap = true, silent = true })
