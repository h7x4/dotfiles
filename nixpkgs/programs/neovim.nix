{ pkgs, home, colorTheme, ... }:
{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-commentary
      vim-gitgutter
      fzf-vim
      vim-which-key
      vim-nix
      vim-surround
      vim-fugitive
      vim-css-color
      semshi
      goyo-vim
      limelight-vim
      vim-tmux-navigator
      vim-polyglot
      lightline-vim
      {
        plugin = rainbow;
        config = ''
          let g:rainbow_active = 1
        '';
      }
      {
        plugin = vim-monokai;
        config = ''
          colorscheme monokai
          autocmd ColorScheme * highlight Normal ctermbg=0
          autocmd ColorScheme * highlight LineNr ctermbg=0
          autocmd ColorScheme * highlight CursorLineNR ctermbg=0 ctermfg=208
          autocmd ColorScheme * highlight SignColumn ctermbg=0
          autocmd ColorScheme * highlight GitGutterAdd ctermbg=0
          autocmd ColorScheme * highlight GitGutterChange ctermbg=0
          autocmd ColorScheme * highlight GitGutterDelete ctermbg=0
        '';
      }
    ];

    extraConfig =  ''
      set clipboard+=unnamedplus
      set number relativenumber
    '';
  };

  home.sessionVariables = { EDITOR = "nvim"; };
}
