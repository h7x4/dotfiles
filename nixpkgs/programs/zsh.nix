{ pkgs, lib, config, ... }:
{
  programs.zsh = rec {
    enable = true;
    dotDir = ".config/zsh";
    # enableSyntaxHighlighting = true;
    defaultKeymap = "viins";
  
    plugins = [
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
      {
        name = "zsh-you-should-use";
        src = pkgs.zsh-you-should-use;
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      # {
      #   name = "powerlevel10k-config";
      #   src = lib.cleanSource ./p10k-config;
      #   file = "p10k.zsh";
      # }
    ];
  
    localVariables = {
      POWERLEVEL9K_LEFT_PROMPT_ELEMENTS = ["dir" "vcs"];
      # NIX_PATH = ''$HOME/.nix-defexpr/channels$\{NIX_PATH:+:}$NIX_PATH'';
    };
  
    shellAliases = with pkgs; let

      sedColor =
        color:
        inputPattern:
        outputPattern:
        "-e \"s|${inputPattern}|${outputPattern.before or ""}$(tput setaf ${toString color})${outputPattern.middle}$(tput op)${outputPattern.after or ""}|g\"";

      colorRed = sedColor 1;

      shellPipe = lib.strings.concatStringsSep " | ";
      join = lib.strings.concatStringsSep " ";

    in {
  
      # This for some reason uses an outdated version of hm
      # hs = "${pkgs.home-manager}/bin/home-manager switch";
  
      hms = "home-manager switch";
      nos = "sudo ${nixos-rebuild}/bin/nixos-rebuild switch";
      ns = "nix-shell";

      # Having 'watch' with a space after as an alias, enables it to expand other aliases
      watch = "${procps}/bin/watch ";
  
      m = "${ncmpcpp}/bin/ncmpcpp";
      p = "${python39Packages.ipython}/bin/ipython";
  
      lls = "${coreutils}/bin/ls";
      ls = "${exa}/bin/exa";
      la = "${exa}/bin/exa -lah --changed --time-style long-iso --git --group";
      lsa = "la";

      killall = "echo \"killall is dangerous on non-gnu platforms. Using 'pkill -x'\"; pkill -x";
  
      youtube-dl-list = join [
        "${youtube-dl}/bin/youtube-dl"
        "-f \"bestvideo[ext=mp4]+bestaudio[e=m4a]/bestvideo+bestaudio\""
        "-o \"%(playlist_index)s-%(title)s.%(ext)s\""
      ];

      music-dl = "${youtube-dl}/bin/youtube-dl --extract-audio -f \"bestaudio[ext=m4a]/best\"";
      music-dl-list = join [
        "${youtube-dl}/bin/youtube-dl"
        "--extract-audio"
        "-f \"bestaudio[ext=m4a]/best\""
        "-o \"%(playlist_index)s-%(title)s.%(ext)s\""
      ];
  
      skusho = "${maim}/bin/maim --hidecursor --nokeyboard $(echo $SCREENSHOT_DIR)/$(date_%s).png";
      skushoclip = shellPipe [
        "${maim}/bin/maim --hidecursor --nokeyboard --select"
        "${xclip}/bin/xclip -selection clipboard -target image/png -in"

      ];
  
      view-latex = "${texlive.combined.scheme-full}/bin/latexmk -pdf -pvc main.tex";
  
      reload-tmux = "${tmux}/bin/tmux source $HOME/.config/tmux/tmux.conf";
  
      ag="${ripgrep}/bin/rg";
  
      dp = "${dropbox-cli}/bin/dropbox";
  
      cd = "z";
  
      ccp = "${coreutils}/bin/cp";
      cp  = "${rsync}/bin/rsync --progress --human-readable";
      cpr = "${rsync}/bin/rsync --progress --human-readable --recursive";
  
      ccat = "${coreutils}/bin/cat";
      cat  = "${bat}/bin/bat";
  
      htop = "${bottom}/bin/bottom";
  
      ps = "${procs}/bin/procs";
  
      fin = "${fd}/bin/fd";

      ip = "ip -c";
  
      connectedIps = shellPipe [
        "netstat -tn 2>/dev/null"
        "grep :$1"
        "awk '{print $5}'"
        "cut -d: -f1"
        "sort"
        "uniq -c"
        "sort -nr"
        "head"
      ];

      path = let
        colorSlashes = colorRed "/" {middle = "/";};
      in
        "echo $PATH | sed -e 's/:/\\n/g' ${colorSlashes} | sort";

      aliases = let
        colorAliasNames = colorRed "\\(^[^=]*\\)=" {middle = "\\1"; after = "\\t";};

        # The '[^]]' (character before /nix should not be ']') is there so that this alias'
        # definition won't be removed.
        removeNixLinks = "-e 's|\\([^]]\\)/nix/store/.*/bin/|\\1|'";
      in
        shellPipe [
          "alias"
          "sed ${colorAliasNames} ${removeNixLinks}"
          "column -ts $'\\t'"
        ];
         
  
      ports = let 
        colorSlashes = colorRed "/" {middle = "/";};
        colorFirstColumn = colorRed "(^[^ ]+)" {middle = "\\1";};
      in
        shellPipe [
          "sudo netstat -tulpn"
          "grep LISTEN"
          "sed -r 's/\\s+/ /g'"
          "cut -d' ' -f 4,7"
          "column -t"
          "sed -r ${colorFirstColumn} ${colorSlashes}"
        ];
  
      }
      //
      (let
        inherit (lib.strings) concatStrings concatStringsSep;
        inherit (lib.lists) range flatten;
        inherit (lib.attrsets) nameValuePair;
        inherit (lib.trivial) const;

        repeatItem = n: item: map (const item) (range 1 n);
        repeatString = n: string: concatStrings (repeatItem n string);

        nthCds = n: [
          ("cd" + (repeatString (n + 1) "."))
          ("cd." + toString n)
          (repeatString (n + 1) ".")
          ("." + toString n)
          (".." + toString n)
        ];
        realCommand = n: "cd " + (concatStringsSep "/" (repeatItem n ".."));

        nthCdsAsNameValuePairs = n: map (cmd: nameValuePair cmd (realCommand n)) (nthCds n);
        allCdNameValuePairs = (flatten (map nthCdsAsNameValuePairs (range 1 9)));
      in 
        builtins.listToAttrs allCdNameValuePairs);
  
    initExtra = ''
      source ${config.home.homeDirectory}/${dotDir}/p10k.zsh
    '';
  };
}
