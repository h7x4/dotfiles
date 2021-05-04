-- Map leader to space
vim.g.mapleader = ' '

local fn = vim.fn
local execute = vim.api.nvim_command

require('settings')
require('plugins')
require('keys')

vim.cmd 'colorscheme monokai'

require('plugin-settings')

-- Setup Lua language server using submodule
-- require('lsp_lua')

-- Another option is to groups configuration in one folder
-- require('config')

-- OR you can invoke them individually here
--require('config.colorscheme')  -- color scheme
--require('config.completion')   -- completion
--require('config.fugitive')     -- fugitive

