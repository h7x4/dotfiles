{ ... }:
{
  programs.gh = {
    enable = true;
    gitProtocol = "ssh";
    aliases = {
      co = "pr checkout";
      pv = "pr view";
    };
  };
}
