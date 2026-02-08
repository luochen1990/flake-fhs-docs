{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/virtualisation/qemu-vm.nix")
  ];

  # Boot configuration
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  # Network configuration
  networking.hostName = "flake-fhs-docs-demo";
  networking.firewall.enable = false;

  # Timezone and locale
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  # User configuration
  users.users.demo = {
    isNormalUser = true;
    password = "demo";
    extraGroups = [ "wheel" ];
  };

  # Enable sudo
  security.sudo.wheelNeedsPassword = false;

  # Enable flake-fhs-docs service
  services.flake-fhs-docs = {
    enable = true;
    listenAddress = "0.0.0.0";
    port = 4321;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    nano
    curl
    wget
    htop
  ];

  # VM specific settings
  virtualisation = {
    memorySize = 1024;
    cores = 2;
    graphics = false;
    forwardPorts = [
      {
        from = "host";
        host.port = 4321;
        guest.port = 4321;
      }
    ];
  };

  # Systemd service to show welcome message
  systemd.services.welcome-message = {
    description = "Show welcome message";
    after = [
      "network.target"
      "flake-fhs-docs.service"
    ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo \"========================================\nFlake FHS Docs Demo VM\n========================================\n\nAccess the documentation site:\n  http://localhost:4321\n\nSSH access:\n  ssh demo@localhost -p 2222\n  (password: demo)\n\nService status:\n  systemctl status flake-fhs-docs\n\nView logs:\n  journalctl -u flake-fhs-docs -f\n\n========================================\"'";
    };
  };

  system.stateVersion = "24.11";
}
