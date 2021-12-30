{ pkgs, config, secrets, ... }:
  # TODO: fix lib
  let lib = pkgs.lib; in
{
  services.nginx = let
    generateServerAliases =
      domains: subdomains:
      lib.lists.flatten (map (s: map (d: "${s}.${d}") domains) subdomains);
  in {
    enable = true;

    recommendedGzipSettings = true; recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = let
      inherit (lib.attrsets) nameValuePair listToAttrs;
      inherit (lib.lists) head drop;
      inherit (secrets) domains ips ports keys;

      makeHost =
        subdomains: extraSettings:
        nameValuePair "${head subdomains}.${head domains}" ({
          serverAliases = drop 1 (generateServerAliases domains subdomains);
          
          # TODO: fix ACME
          # enableACME = true;
          forceSSL = true;
          sslCertificate = keys.certificates.default.cert;
          sslCertificateKey = keys.certificates.default.key;

        } // extraSettings);

      makePassHost =
        subdomains: extraSettings:
        makeHost subdomains ({ basicAuthFile = keys.htpasswds.default; } // extraSettings);

      makeProxy = 
        subdomains: url: extraSettings:
        makeHost subdomains ({ locations."/".proxyPass = url; } // extraSettings);

      makePassProxy = 
        subdomains: url: extraSettings:
        makeProxy subdomains url ({basicAuthFile = keys.htpasswds.default;} // extraSettings);

      s = toString;

    in listToAttrs [
      (makeProxy ["git" "gitlab"] "http://unix:/run/gitlab/gitlab-workhorse.socket" {})
      (makePassProxy ["plex"] "http://localhost:${s ports.plex}" {})
      (makeHost ["www"] { root = "/var/www/blog"; })
      (makePassHost ["cache"] { root = "/var/lib/nix-cache"; })
      (makePassProxy ["px1"] "https://${ips.px1}:${s ports.proxmox}" {})
      (makePassProxy ["idrac"] "https://${ips.idrac}" {})
      # (makePassProxy ["log"] "https://localhost:${s ports.grafana}" { proxyWebsockets = true; })
      # (makeProxy ["wiki"] "" {})
      # (makeHost ["vpn"] "" {})
      (makePassProxy ["hydra"] "http://localhost:${s ports.hydra}" {})
      # (makePassProxy ["sync" "drive"] "" {})
      # (makePassProxy ["music" "mpd"] "" {})
    ];

    upstreams = {};

    streamConfig = ''
      upstream minecraft {
        server 10.0.0.206:25565;
      }

      server {
        listen 0.0.0.0:25565;
        listen [::0]:25565;
        proxy_pass minecraft;
      }
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 25565 ];
}
