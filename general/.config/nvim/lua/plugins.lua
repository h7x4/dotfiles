-- vim.cmd [[packadd packer.nvim]]
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    execute 'packadd packer.nvim'
end

vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

-- require('packer').init({display = {non_interactive = true}})
require('packer').init({display = {auto_clean = false}})

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use 'crusoexia/vim-monokai'

    use 'airblade/vim-gitgutter'

    use 'junegunn/fzf.vim'
    use 'tpope/vim-commentary'

    use 'tmux-plugins/vim-tmux'
    use 'christoomey/vim-tmux-navigator'
    use 'junegunn/goyo.vim'
    use 'junegunn/limelight.vim'
    use 'liuchengxu/vim-which-key'

    use 'sheerun/vim-polyglot'
    use 'numirias/semshi'
end)
