{ ... }:
{
  # TODO: Make secret keys.
  services.searx = {
    enable = false;
    settings = {
      server.port = 8080;
      server.bind_address = "0.0.0.0";
      server.secret_key = "@SEARX_SECRET_KEY@";
     
      engines = [
        {
          name = "wolframalpha";
          shortcut = "wa";
          api_key = "@WOLFRAM_API_KEY@";
          engine = "wolframalpha_api";
        };
      ];
    };

    # runInUwsgi = true;
    # uwsgiConfig = {
      # disable-logging = false;
      # http = ":11000";
      # socket = "/run/searx/searx.sock";
    # };
  };
}
