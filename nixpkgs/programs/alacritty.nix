{ lib, pkgs, colorTheme, ... }:
{
  programs.alacritty = { enable = true; settings = { window.padding = { x = 15; y = 15; }; font = { normal = { family = "Fira Code"; style = "Retina"; }; bold.family = "Fira Code"; italic.family = "Fira Code"; size = 12.0; }; 
      colors =
        let 
          pColors = [ "foreground" "background" ];
        in
          {
            primary = lib.attrsets.getAttrs pColors colorTheme.default;
            normal =  lib.attrsets.filterAttrs (n: v: pColors ? n) colorTheme.default;
          };
  
      background_opacity = 1.0;
  
      cursor = {
        style = "Block";
        blinking = "On";
        unfocused_hollow = true;
      };
  
      live_config_reload = true;
  
      shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [ "--login" ];
      };
    };
  };
}
