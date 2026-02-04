# Linux (NixOS) specific configuration

{ config, pkgs, ... }:

{
  # System configuration
  system.stateVersion = "24.11"; # Change this to your NixOS version

  # Linux-specific packages
  environment.systemPackages = [
    # Add Linux-specific packages here
  ];

  # Boot configuration (example - adjust as needed)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}

