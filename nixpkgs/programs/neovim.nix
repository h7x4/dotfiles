{pkgs, ...}:
{
  programs.neovim = {
    enable = true;
    # defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig =  ''
      set clipboard+=unnamedplus
    '';
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
      {
        plugin = vim-monokai;
        config = ''
          colorscheme monokai
        '';
      }
    ];
  };
}
