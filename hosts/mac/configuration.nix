# macOS (darwin) specific configuration

{ config, pkgs, inputs, ... }:

{
  # Primary user for user-specific configurations
  system.primaryUser = "dan";

  # Used for backwards compatibility
  system.stateVersion = 6;

  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Add user to admin group before any installation
  system.activationScripts.addUserToAdmin = ''
    echo "adding ${config.system.primaryUser} to admin group..." >&2
    dseditgroup -o edit -a ${config.system.primaryUser} -t user admin 2>/dev/null || true
  '';


  # nix-homebrew configuration (macOS only)
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = config.system.primaryUser;
    autoMigrate = true;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
    mutableTaps = false;
  };

  # Homebrew packages and casks (macOS only)
  homebrew = {
    enable = true;
    brews = [ "mas" "brew-php-switcher" ];
    casks = [ "cursor" "lm-studio" ];
    masApps = {
      "WhatsApp" = 310633997;
    };
    onActivation.cleanup = "zap";
  };
}

