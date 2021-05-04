
vim.wo.relativenumber = true
vim.cmd 'set nu rnu'            -- Make current linenumber absolute

vim.o.clipboard = "unnamedplus" -- Copy paste between vim and everything else
vim.wo.scrolloff = 5            -- Start scrolling when n lines from edge

vim.api.nvim_set_option('smarttab', true)
vim.api.nvim_set_option('cindent', true)
vim.api.nvim_set_option('expandtab', true)
vim.api.nvim_set_option('breakindent', true) -- Wrapped lines gets indented
vim.api.nvim_set_option('tabstop', 2)
vim.api.nvim_set_option('shiftwidth', 2)

vim.cmd 'set formatoptions-=cro' -- No continued comment on <return>

vim.api.nvim_set_option('termguicolors', true)

vim.wo.conceallevel = 2
