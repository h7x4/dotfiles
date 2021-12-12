{ pkgs, lib, config, shellOptions, ... }:
{
  programs.zsh = rec {
    enable = true;
    dotDir = ".config/zsh";
    # enableSyntaxHighlighting = true;
    defaultKeymap = "viins";

    plugins = [
      # {
      #   name = "nix-zsh-shell-integration";
      #   src = pkgs.nix-zsh-shell-integration;
      # }
      {
        name = "zsh-fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
      }
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

    localVariables = shellOptions.variables;

    shellAliases = shellOptions.flattened.aliases;

    # initExtra = let
    #   functions = {
    #     # TODO: make 'join' available.
    #     md-to-pdf = join [
    #       "pandoc \"$1\""
    #       "-f gfm"
    #       "-V linkcolor:blue"
    #       "-V geometry:a4paper"
    #       "-V geometry:margin=2cm"
    #       "-V mainfont=\"Droid Sans\""
    #       "--pdf-engine=xelatex"
    #       "-o \"$2\""
    #     ];
    #   };
    # in ''
    initExtra = ''
      source ${config.home.homeDirectory}/${dotDir}/p10k.zsh
    '';
  };
}
