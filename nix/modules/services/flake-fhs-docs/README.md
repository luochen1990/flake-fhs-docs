# Flake FHS Docs NixOS Module

This module provides a NixOS service for running the Flake FHS documentation site.

## Quick Start

### Basic Setup

Enable the service with default settings:

```nix
{ config, pkgs, ... }:
{
  services.flake-fhs-docs.enable = true;
}
```

This will:
- Start the documentation preview server on `http://127.0.0.1:4321`
- Use the default flake-fhs-docs package from nixpkgs

### Custom Port

```nix
services.flake-fhs-docs = {
  enable = true;
  port = 8080;
};
```

### Expose on Network

```nix
services.flake-fhs-docs = {
  enable = true;
  listenAddress = "0.0.0.0";
  openFirewall = true;
};
```

## Advanced Configuration

### Nginx Reverse Proxy

Use nginx as a reverse proxy with SSL:

```nix
services.flake-fhs-docs = {
  enable = true;
  nginx = {
    enable = true;
    hostName = "docs.example.com";
    useSSL = true;
    forceSSL = true;
  };
};
```

This will:
- Configure nginx as a reverse proxy
- Enable ACME certificate management (requires `security.acme`)
- Force HTTPS redirects

### Using a Custom Package

```nix
services.flake-fhs-docs = {
  enable = true;
  package = pkgs.flake-fhs-docs.overrideAttrs (old: {
    # Custom overrides if needed
  });
};
```

## Options

- `services.flake-fhs-docs.enable` (boolean): Enable the service (default: false)
- `services.flake-fhs-docs.package` (package): The flake-fhs-docs package to use
- `services.flake-fhs-docs.listenAddress` (string): Address to listen on (default: "127.0.0.1")
- `services.flake-fhs-docs.port` (port): Port for the preview server (default: 4321)
- `services.flake-fhs-docs.openFirewall` (boolean): Open the port in firewall (default: false)
- `services.flake-fhs-docs.nginx.enable` (boolean): Configure nginx reverse proxy (default: false)
- `services.flake-fhs-docs.nginx.hostName` (string): Host name for nginx virtual host
- `services.flake-fhs-docs.nginx.useSSL` (boolean): Enable SSL/HTTPS (default: true)
- `services.flake-fhs-docs.nginx.forceSSL` (boolean): Force HTTPS redirect (default: true)

## Systemd Service

The module creates a systemd service named `flake-fhs-docs` with:

- Auto-restart on failure
- Private tmp and security hardening
- Proper environment variables for port and host

### Managing the Service

```bash
# Start the service
sudo systemctl start flake-fhs-docs

# Stop the service
sudo systemctl stop flake-fhs-docs

# Restart the service
sudo systemctl restart flake-fhs-docs

# View service status
sudo systemctl status flake-fhs-docs

# View logs
sudo journalctl -u flake-fhs-docs -f
```

## Complete Example

```nix
{ config, pkgs, ... }:
{
  services.flake-fhs-docs = {
    enable = true;
    listenAddress = "0.0.0.0";
    port = 4321;
    nginx = {
      enable = true;
      hostName = "docs.example.com";
      useSSL = true;
      forceSSL = true;
    };
  };

  # Required for Let's Encrypt certificates
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@example.com";
  };

  # Optional: Open firewall for direct access
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
```

## Notes

- The preview server is a minimal Node.js HTTP server serving static files
- For production deployments, consider using a more robust HTTP server (nginx, caddy) to serve the static files directly
- The nginx proxy configuration is suitable for most use cases
- Ensure DNS is properly configured if using nginx with SSL
