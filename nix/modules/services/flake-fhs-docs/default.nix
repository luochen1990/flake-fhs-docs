{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.flake-fhs-docs;
  previewServerScript = pkgs.writeShellApplication {
    name = "flake-fhs-docs-preview";
    text = ''
      export FLAKE_FHS_DOCS_ROOT="${cfg.package}/share/www"
      exec ${cfg.package}/bin/flake-fhs-docs-preview
    '';
  };
in
{
  config = lib.mkIf cfg.enable {
    systemd.services.flake-fhs-docs = {
      description = "Flake FHS Documentation Site";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${previewServerScript}/bin/flake-fhs-docs-preview";
        Restart = "on-failure";
        RestartSec = "5s";
        Environment = [
          "PORT=${toString cfg.port}"
          "HOST=${cfg.listenAddress}"
        ];
        WorkingDirectory = "${cfg.package}/share/www";
        ReadOnlyPaths = [ "${cfg.package}/share/www" ];
        PrivateTmp = true;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = true;

      virtualHosts.${cfg.nginx.hostName} = {
        enableACME = cfg.nginx.useSSL;
        forceSSL = cfg.nginx.forceSSL && cfg.nginx.useSSL;

        locations."/" = {
          proxyPass = "http://${cfg.listenAddress}:${toString cfg.port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
  };
}
