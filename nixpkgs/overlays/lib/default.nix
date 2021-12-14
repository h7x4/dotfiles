self: super: 
{
  lib = super.lib // {
    attrsets = import ./attrsets.nix self super;
    lists = import ./lists.nix self super;
    strings = import ./strings.nix self super;
    termColors = import ./termColors.nix self super;
  };
}
