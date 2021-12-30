{ ... }:
{
  services.grafana = {
    enable = true;
    domain = "log.nani.wtf";
    port = 9000;
    addr = "127.0.0.1";
  };

  services.prometheus = {
    enable = true;
    port = 9001;

    exporters = {
      
    };
  };

  services.loki = {
    enable = true;
    # configFile = ./loki-local-config.yaml;
  };

}
