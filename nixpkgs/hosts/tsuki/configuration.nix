{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./services/nginx.nix

      ../../pluggables/server/dokuwiki.nix
      ../../pluggables/server/gitlab
      # ../../pluggables/server/minecraft.nix
      ../../pluggables/server/plex.nix
      ../../pluggables/server/hydra.nix
      # ../../pluggables/server/matrix.nix
      # ../../pluggables/server/libvirt.nix
      # ../../pluggables/server/grafana.nix
      # ../../pluggables/server/discord-bot.nix
      # ../../pluggables/server/calibre.nix
      # ../../pluggables/server/openvpn.nix
      # ../../pluggables/server/samba.nix
      # ../../pluggables/server/searx.nix
      # ../../pluggables/server/syncthing.nix
    ];

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  boot.loader = {
    grub = {
      enable = true;
      version = 2;
      efiSupport = true;
      fsIdentifier = "label";
      device = "nodev";
      efiInstallAsRemovable = true;
    };
    # efi.efiSysMountPoint = "/boot/efi";
    # efi.canTouchEfiVariables = true;
  };

  time.timeZone = "Europe/Oslo";

  networking = {
    hostName = "Tsuki";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.ens18.useDHCP = true;
    # firewall = {
    #   allowedTCPPorts = [ ... ];
    #   allowedUDPPorts = [ ... ];
    #   enable = false;
    # };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {
    openssh.enable = true;
    printing.enable = true;
    cron = {
      enable = true;
      systemCronJobs = [
    #     "*/5 * * * *      root    date >> /tmp/cron.log"
      ];
    };
  };

  users.users.h7x4 = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "disk"
      "libvirtd"
      "input"
    ];
    shell = pkgs.zsh;
  };

  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    systemPackages = with pkgs; [
      wget
    ];

    shells = with pkgs; [
      bashInteractive
      zsh
      dash
    ];

    etc = {
      sudoLecture = {
        target = "sudo.lecture";
        text = "[31mBe careful or something, idk...[m\n";
      };

      currentSystemPackages = {
        target = "current-system-packages";
        text = let
          inherit (lib.strings) concatStringsSep;
          inherit (lib.lists) sort;
          inherit (lib.trivial) lessThan;
          packages = map (p: "${p.name}") config.environment.systemPackages;
          sortedUnique = sort lessThan (lib.unique packages);
        in concatStringsSep "\n" sortedUnique;
      };
    };
  };

  fonts = {
    enableDefaultFonts = true;

    fonts = with pkgs; [
      cm_unicode
      dejavu_fonts
      fira-code
      fira-code-symbols
      powerline-fonts
      iosevka
      symbola
      corefonts
      ipaexfont
      ipafont
      liberation_ttf
      migmix
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      open-sans
      source-han-sans
      source-sans
      ubuntu_font_family
      victor-mono
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Droid Sans Serif" "Ubuntu" ];
        sansSerif = [ "Droid Sans" "Ubuntu" ];
        monospace = [ "Fira Code" "Ubuntu" ];
        emoji = [ "Noto Sans Emoji" ];
      };
    };
  };

  programs = {
    git.enable = true;
    npm.enable = true;
    tmux.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      configure = {
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            direnv-vim
            vim-nix
            vim-polyglot
          ];

          opt = [
            vim-monokai
          ];
        };

        customRC = ''
          set number relativenumber
          set undofile
          set undodir=~/.cache/vim/undodir 

          packadd! vim-monokai 
          colorscheme monokai
        '';
      };
    };
  };

  security.sudo.extraConfig = ''
    Defaults    lecture = always
    Defaults    lecture_file = /etc/${config.environment.etc.sudoLecture.target} 
  '';

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  # system.extraDependencies = with pkgs; [
  #   asciidoc
  #   asciidoctor
  #   cabal2nix
  #   clang
  #   dart
  #   dotnet-sdk
  #   dotnet-sdk_3
  #   dotnet-sdk_5
  #   dotnetPackages.Nuget
  #   elm2nix
  #   elmPackages.elm
  #   flutter
  #   gcc
  #   ghc
  #   ghcid
  #   haskellPackages.Cabal_3_6_2_0
  #   maven
  #   nodePackages.node2nix
  #   nodePackages.npm
  #   nodePackages.sass
  #   nodePackages.typescript
  #   nodePackages.yarn
  #   nodejs
  #   plantuml
  #   python3
  #   rustc
  #   rustc
  #   rustup
  # ];

  system.stateVersion = "21.11";
}


