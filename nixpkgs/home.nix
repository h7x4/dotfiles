{ lib, pkgs, ... } @ args:

let
  colorType = with lib.types; (attrsOf str);

  colorTheme = import ./common/colors.nix;
in
{
  _module.args.colorTheme = colorTheme;

  imports = [
    ./programs/alacritty.nix
    ./programs/comma.nix
    ./programs/emacs.nix
    ./programs/gh.nix
    ./programs/git.nix
    ./programs/ncmpcpp.nix
    ./programs/neovim.nix
    ./programs/newsboat.nix
    ./programs/rofi.nix
    ./programs/tmux.nix
    ./programs/vscode.nix
    ./programs/zathura.nix
    ./programs/zsh.nix
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

    # bottom.enable = true;

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

    man = {
      enable = true;
      generateCaches = true;
    };

    obs-studio.enable = true;

    qutebrowser = {
      enable = true;
      aliases = {};
      searchEngines = {};
      settings = {};
      keyBindings = {};
      # quickmarks = {};
      extraConfig = '''';
    };

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

  services.mpd         = import ./services/mpd.nix args;
  services.picom       = import ./services/picom.nix;
  services.stalonetray = import ./services/stalonetray.nix (args // { inherit colorTheme; });
  services.sxhkd       = import ./services/sxhkd.nix args;


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
      calibre
      castnow
      citra
      copyq
      czkawka
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
      google-chrome
      # gpgtui
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

  services.gnome-keyring.enable = true;

  services.dropbox.enable = true;
  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = "32x32";
    };
    settings = {
      global = {
        geometry = "300x5-30+50";
        transparency = 10;
        frame_color = "#eceff1";
        font = "Droid Sans 9";
      };
      urgency_normal = {
        background = "#37474f";
        foreground = "#eceff1";
        timeout = 10;
      };
    };
  };

  services.network-manager-applet.enable = true;

  # services.redshift.enable = true;

}

