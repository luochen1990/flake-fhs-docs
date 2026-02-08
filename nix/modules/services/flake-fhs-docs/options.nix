{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.services.flake-fhs-docs = {
    enable = lib.mkEnableOption "Flake FHS Docs documentation site service";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.flake-fhs-docs;
      description = ''
        The flake-fhs-docs package to use.
        Default is the package from nixpkgs.
      '';
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = ''
        Address to listen on for the preview server.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 4321;
      description = ''
        Port for the preview server.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the configured port in the firewall.
      '';
    };

    nginx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to configure nginx as a reverse proxy for the docs site.
        '';
      };

      hostName = lib.mkOption {
        type = lib.types.str;
        example = "docs.example.com";
        description = ''
          Host name for nginx virtual host.
        '';
      };

      useSSL = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable SSL/HTTPS for nginx.
        '';
      };

      forceSSL = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to force redirect to HTTPS.
        '';
      };
    };
  };
}
