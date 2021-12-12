{ pkgs ? import <nixos> {}, lib ? pkgs.lib, config ? pkgs.config, ... }:
let
  sedColor =
    color:
    inputPattern:
    outputPattern:
    "-e \"s|${inputPattern}|${outputPattern.before or ""}$(tput setaf ${toString color})${outputPattern.middle}$(tput op)${outputPattern.after or ""}|g\"";

  colorRed = sedColor 1;

  colorSlashes = colorRed "/" {middle = "/";};

  red = s: "[31m${s}[m";
  green = s: "[32m${s}[m";
  blue = s: "[34m${s}[m";

  # Context Functors
  functors = let
    inherit (lib.strings) concatStringsSep;
  in {
    shellPipe = {
      wrap = s: {
        type = "shellPipe";
        value = s;
      };
      apply = f: concatStringsSep " | " f.value;
      stringify = f: concatStringsSep (blue "\n| ") f.value;
    };
    join = {
      wrap = s: {
        type = "join";
        value = s;
      };
      apply = f: concatStringsSep " " f.value;
      stringify = f: concatStringsSep (" \\\n    " f.value;
    };
  };

  # AttrSet -> Bool
  isFunctor = attrset: if !(attrset ? "type") then false else lib.lists.any (f: (f.wrap "").type == attrset.type) (lib.attrsets.attrValues functors);

  repeatItem = n: item: map (lib.trivial.const item) (lib.lists.range 1 n);
  repeatString = n: string: lib.strings.concatStrings (repeatItem n string);

in rec {
  _module.args.shellOptions = {
    aliases = let
      shellPipe = functors.shellPipe.wrap;
      join = functors.join.wrap;
    in with pkgs; {

      # ░█▀▄░█▀▀░█▀█░█░░░█▀█░█▀▀░█▀▀░█▄█░█▀▀░█▀█░▀█▀░█▀▀
      # ░█▀▄░█▀▀░█▀▀░█░░░█▀█░█░░░█▀▀░█░█░█▀▀░█░█░░█░░▀▀█
      # ░▀░▀░▀▀▀░▀░░░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░░▀░░▀▀▀

      # Replacing all of coreutils with rust, lol

      "System Tool Replacements" = {
        cd = "z";

        ccp = "${coreutils}/bin/cp";
        cp  = "${rsync}/bin/rsync --progress --human-readable";
        cpr = "${rsync}/bin/rsync --progress --human-readable --recursive";

        ccat = "${coreutils}/bin/cat";
        cat  = "${bat}/bin/bat";

        htop = "${bottom}/bin/btm";

        # This is potentially dangerous, as procs flags are totally different
        ps = "${procs}/bin/procs";

        # Find flags are so different that I've renamed fd to fin for time being
        fin = "${fd}/bin/fd";

        ag="${ripgrep}/bin/rg";

        lls = "${coreutils}/bin/ls --color=always";
        ls = "${exa}/bin/exa";
        la = "${exa}/bin/exa -lah --changed --time-style long-iso --git --group";
        lsa = "la";

        killall = "echo \"killall is dangerous on non-gnu platforms. Using 'pkill -x'\"; pkill -x";
      };

      # ░█▀▀░█▀█░█░░░█▀█░█▀▄░▀█▀░▀▀█░█▀▀░█▀▄
      # ░█░░░█░█░█░░░█░█░█▀▄░░█░░▄▀░░█▀▀░█░█
      # ░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀▀░

      # Normal commands, just with colors.

      "Colorized" = {
        ip = "ip --color=always";
        diff = "diff --color=auto";
        grep = "grep --color=always";
        make = "${colormake}/bin/colormake";
      };

      # ░█▀▄░█▀▀░█▄█░▀█▀░█▀█░█▀▄░█▀▀░█▀▄░█▀▀
      # ░█▀▄░█▀▀░█░█░░█░░█░█░█░█░█▀▀░█▀▄░▀▀█
      # ░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀░▀░▀▀▀

      # Stuff that I constantly forget...

      "Reminders" = {
        regex-escapechars = "echo \"[\\^$.|?*+()\"";
        aliases = "${coreutils}/bin/cat $HOME/${home.file.aliases.target}";
      };

      # ░█▀█░▀█▀░█░█
      # ░█░█░░█░░▄▀▄
      # ░▀░▀░▀▀▀░▀░▀

      # Nix related aliases

      "Nix Stuff" = {
        # This for some reason uses an outdated version of hm
        # hs = "${pkgs.home-manager}/bin/home-manager switch";
        hms = "home-manager switch";
        nxr = "sudo ${nixos-rebuild}/bin/nixos-rebuild switch";
        nxc = "sudoedit /etc/nixos/configuration.nix";
        nxh = "vim ~/.config/nixpkgs/home.nix";
        ns = "nix-shell";
      };

      # ░█▀▀░█▀█░█▀▀░▀█▀░█░█░█▀█░█▀▄░█▀▀
      # ░▀▀█░█░█░█▀▀░░█░░█▄█░█▀█░█▀▄░█▀▀
      # ░▀▀▀░▀▀▀░▀░░░░▀░░▀░▀░▀░▀░▀░▀░▀▀▀

      # Aliases that are so long/piped that they could be considered new software.

      "Software" = {

        skusho = "${maim}/bin/maim --hidecursor --nokeyboard $(echo $SCREENSHOT_DIR)/$(date_%s).png";
        skushoclip = shellPipe [
          "${maim}/bin/maim --hidecursor --nokeyboard --select"
          "${xclip}/bin/xclip -selection clipboard -target image/png -in"
        ];

        dp-check = shellPipe [
          "ls -l /proc/$(pidof dropbox)/fd"
          "egrep -v 'pipe:|socket:|/dev'"
          "grep \"${config.services.dropbox.path}/[^.]\""
      ];

        subdirs-to-cbz = join [
          "for dir in \"./*\"; do"
          "  ${zip}/bin/zip -r \"$dir.cbz\" \"$d\";"
          "done"
        ];

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

        path = "echo $PATH | sed -e 's/:/\\n/g' ${colorSlashes} | sort";

        wowify = "${toilet}/bin/toilet -f pagga | ${lolcat}/bin/lolcat";

        aliasc = let
          colorAliasNames = colorRed "\\(^[^=]*\\)=" {middle = "\\1"; after = "\\t";};
          # The '[^]]' (character before /nix should not be ']') is there so that this
          # alias definition won't be removed.
          removeNixLinks = "-e 's|\\([^]]\\)/nix/store/.*/bin/|\\1|'";
        in
          shellPipe [
            "alias"
            "sed ${colorAliasNames} ${removeNixLinks}"
            "column -ts $'\\t'"
          ];

        ports = let
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
      };

      # ░█▀█░█░░░▀█▀░█▀█░█▀▀░█▀▀░█▀▀
      # ░█▀█░█░░░░█░░█▀█░▀▀█░█▀▀░▀▀█
      # ░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀

      # Normal commands that are just shortened. What would normally be considered
      # the "technically correct definition" of an alias

      "Actual Aliases" = {
        dp = "${dropbox-cli}/bin/dropbox";

        # Having 'watch' with a space after as an alias, enables it to expand other aliases
        watch = "${procps}/bin/watch ";

        m = "${ncmpcpp}/bin/ncmpcpp";
        p = "${python39Packages.ipython}/bin/ipython";
      };

      # ░█▄█░▀█▀░█▀▀░█▀▀
      # ░█░█░░█░░▀▀█░█░░
      # ░▀░▀░▀▀▀░▀▀▀░▀▀▀

      # I didn't know where else to put these ¯\_(ツ)_/¯

      "Misc" = {
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

        view-latex = "${texlive.combined.scheme-full}/bin/latexmk -pdf -pvc main.tex";

        reload-tmux = "${tmux}/bin/tmux source $HOME/.config/tmux/tmux.conf";
      };

      # ░█▀▀░█▀▀░█▀█░█▀▀░█▀▄░█▀█░▀█▀░█▀▀░█▀▄
      # ░█░█░█▀▀░█░█░█▀▀░█▀▄░█▀█░░█░░█▀▀░█░█
      # ░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░▀░░▀▀▀░▀▀░

      # Code generated commands

      "Generated" = {
        "cds" = let
          inherit (lib.strings) concatStrings concatStringsSep;
          inherit (lib.lists) range flatten;
          inherit (lib.attrsets) nameValuePair;

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
          lib.attrsets.listToAttrs allCdNameValuePairs;
      };
    };

    # TODO: flatten functions
    functions = {
      all = {
        md-to-pdf = functors.join.wrap [
          "pandoc \"$1\""
          "-f gfm"
          "-V linkcolor:blue"
          "-V geometry:a4paper"
          "-V geometry:margin=2cm"
          "-V mainfont=\"Droid Sans\""
          "--pdf-engine=xelatex"
          "-o \"$2\""
        ];
      };
    };

    variables = {
      POWERLEVEL9K_LEFT_PROMPT_ELEMENTS = ["dir" "vcs"];
      # NIX_PATH = ''$HOME/.nix-defexpr/channels$\{NIX_PATH:+:}$NIX_PATH'';
    };

    flattened.aliases = let
      inherit (lib.attrsets) mapAttrs attrValues filterAttrs isAttrs;
      inherit (lib.lists) foldr partition;
      inherit (lib.strings) isString concatStringsSep;

      applyFunctor = attrset: functors.${attrset.type}.apply attrset;

      # TODO: better naming
      allAttrValuesAreStrings = attrset: let

        # [ {String} ]
        filteredAliases = [(filterAttrs (n: v: isString v) attrset)];

        # [ {String} ]
        remainingFunctors = let
          functorSet = filterAttrs (n: v: isAttrs v && isFunctor v) attrset;
          appliedFunctorSet = mapAttrs (n: v: applyFunctor v) functorSet;
        in [ appliedFunctorSet ];

        # [ {AttrSet} ]
        remainingAliasSets = attrValues (filterAttrs (n: v: isAttrs v && !(isFunctor v)) attrset);

        # [ {String} ]
        recursedAliasSets = filteredAliases
                          ++ (remainingFunctors)
                          ++ (map allAttrValuesAreStrings remainingAliasSets);
      in foldr (a: b: a // b) {} recursedAliasSets;

    in
      allAttrValuesAreStrings _module.args.shellOptions.aliases;
  };

  home.file.aliases = {
    text = let
      inherit (lib.strings) concatStringsSep replaceStrings substring stringLength;
      inherit (lib.attrsets) attrValues mapAttrs isAttrs;
      inherit (lib.lists) remove length range tail;
      inherit (lib.trivial) const;

      # int -> String -> AttrSet -> String
      stringifyCategory = level: name: category:
      concatStringsSep "\n"
        (["${repeatString level "  "}[${green name}]"] ++
        (attrValues (mapAttrs (n: v: let
          # String
          indent = repeatString level "  ";

          # String -> String -> String
          wrap' = w: s: w + s + w;

          # String -> String
          removeNixLinks = text: let
            maybeMatches = (builtins.match "(|.*[^)])(/nix/store/.*/bin/).*" text);
            matches = if (maybeMatches == null) then null else remove "" maybeMatches;
            listOfEmptyStrings = map (const "") (range 1 (length matches));
          in
            if (maybeMatches == null)
              then text
              else replaceStrings matches listOfEmptyStrings text;

          applyFunctor = attrset: let
            applied = functors.${attrset.type}.stringify attrset;
            indent' = indent + "       " + (repeatString (stringLength n) " ");
            indented = replaceStrings ["\n"] [("\n" + indent')] applied;
          in indented;

          recurse = stringifyCategory (level + 1) n v;
        in
        if !(isAttrs v) then "${indent}  ${red n} -> ${wrap' (blue "\"") (removeNixLinks v)}" else
        if isFunctor v  then "${indent}  ${red n} -> ${wrap' (blue "\"") (removeNixLinks (applyFunctor v))}" else
        recurse) category)));
    in
      (stringifyCategory 0 "Aliases" _module.args.shellOptions.aliases) + "\n";
    target = ".local/share/aliases";
  };
}
