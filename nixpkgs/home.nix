{ pkgs ? import <nixpkgs> {}, lib ? pkgs.lib, ... } @ args:

let
  colorType = with lib.types; (attrsOf str);

  colorTheme = import ./common/colors.nix;
in
{
  _module.args = {
    inherit colorTheme;
  };

  imports = [
    ./shellOptions.nix
    ./packages.nix

    ./misc/mimetypes.nix

    ./programs/alacritty.nix
    ./programs/comma.nix
    ./programs/emacs.nix
    ./programs/gh.nix
    ./programs/git.nix
    ./programs/ncmpcpp.nix
    ./programs/neovim.nix
    ./programs/newsboat.nix
    ./programs/qutebrowser.nix
    ./programs/rofi.nix
    ./programs/tmux.nix
    ./programs/vscode.nix
    ./programs/zathura.nix
    ./programs/zsh.nix

    ./services/dunst.nix
    ./services/mpd.nix
    ./services/picom.nix
    ./services/stalonetray.nix
    ./services/sxhkd.nix

    ./secret
  ];

  home = {
    stateVersion = "21.05";
    username = "h7x4";
    homeDirectory = "/home/h7x4";
  };

  news.display = "silent";

  programs = {
    home-manager.enable = true;

    bat.enable = true;
    bottom.enable = true;
    exa.enable = true;
    feh.enable = true;

    fzf = {
      enable = true;
      defaultCommand = "fd --type f";
    };

    gpg.enable = true;
    irssi.enable = true;
    lazygit.enable = true;
    mpv.enable = true;
    ssh.enable = true;

    man = {
      enable = true;
      generateCaches = true;
    };

    obs-studio.enable = true;

    skim = {
      enable = true;
      defaultCommand ="fd --type f";
    };

    texlive = {
      enable = true;
      # packageSet = pkgs.texlive.combined.scheme-medium;
    };

    # xmobar.enable = true;

    zoxide.enable = true;
  };

  services = {
    gnome-keyring.enable = true;
    dropbox.enable = true;
    network-manager-applet.enable = true;
    # redshift.enable = true;
  };

  manual = {
    html.enable = true;
    manpages.enable = true;
    json.enable = true;
  };

  gtk = {
    enable = true;
    font = {
      name = "Droid Sans";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
    theme = {
      package = pkgs.vimix-gtk-themes;
      name = "VimixDark";
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  xsession = {
    pointerCursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 16;
    };
  };
}
