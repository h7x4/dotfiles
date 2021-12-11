{ lib, pkgs, ... } @ args:

let
  colorType = with lib.types; (attrsOf str);

  colorTheme = import ./common/colors.nix;
in
{
  _module.args.colorTheme = colorTheme;

  imports = [
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

    ./secret/ssh/hosts
  ];

  xsession = {
    pointerCursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 16;
    };
  };

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

  home = {
    stateVersion = "21.05";
    username = "h7x4";
    homeDirectory = "/home/h7x4";
    packages = with pkgs; [
      ahoviewer
      anki
      asciidoctor
      audacity
      beets
      biber
      calibre
      castnow
      citra
      cool-retro-term
      copyq
      czkawka
      darktable
      desmume
      discord
      diskonaut
      diskus
      docker
      du-dust
      fcitx
      fd
      ffmpeg
      geogebra
      gnome.gnome-font-viewer
      google-chrome
      # gpgtui
      graphviz
      # hck
      hexyl
      imagemagick
      inkscape
      insomnia
      jq
      kepubify
      kid3
      koreader
      krita
      ktouch
      lastpass-cli
      lazydocker
      libreoffice-fresh
      light
      lolcat
      maim
      mdcat
      mdp
      mediainfo
      megacmd
      megasync
      micro
      minecraft
      mkvtoolnix
      mmv
      mopidy
      mopidy-mpd
      mopidy-soundcloud
      mopidy-spotify
      mopidy-youtube
      mpc_cli
      mps-youtube
      neofetch
      nmap
      nyxt
      osu-lazer
      pandoc
      pulseaudio
      pulsemixer
      python3
      ripgrep
      rsync
      sc-im
      scrcpy
      slack
      slack-term
      # steam-tui
      sxiv
      tagainijisho
      taisei
      tealdeer
      teams
      # tenacity
      # tv-renamer
      toilet
      tokei
      touchegg
      w3m
      waifu2x-converter-cpp
      wavemon
      xcalib
      xclip
      xdotool
      youtube-dl
      # yuzu-mainline
      zeal
      zoom-us
      zotero

      # Needed for VSCode liveshare
      desktop-file-utils
      krb5
      zlib
      icu
      openssl
      xorg.xprop
    ];
  };

  services = {
    gnome-keyring.enable = true;
    dropbox.enable = true;
    network-manager-applet.enable = true;
    # redshift.enable = true;
  };

}

