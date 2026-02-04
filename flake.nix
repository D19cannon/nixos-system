{
  description = "Multi-platform nix configuration for darwin and Linux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";

    # nixCats-nvim
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # Optional: Declarative tap management (macOS only)
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, nixCats, homebrew-core, homebrew-cask }:
  let
    # Import nixCats configuration which defines plugins, LSPs, and builds Neovim packages
    # This creates a function that builds nixCats packages for each system architecture
    # Use builtins.path to ensure proper path resolution and avoid symlink issues
    nixCatsConfig = import ./modules/shared/nixcats-config.nix {
      inherit nixCats nixpkgs;
      luaPath = builtins.path {
        path = ./modules/shared/lua;
        name = "nixcats-lua-config";
      };
    };
    buildNixCatsForSystem = nixCatsConfig.buildNixCatsForSystem;
  in
  {
    # macOS (darwin) configurations
    darwinConfigurations = {
      "mac" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs self;
          # Pass the builder function instead of pre-building to avoid evaluation-time circular deps
          buildNixCatsForSystem = buildNixCatsForSystem;
        };
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          # Align homebrew taps config with nix-homebrew
          ({config, ...}: {
            homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
          })
          # Set Git commit hash for darwin-version
          ({self, ...}: {
            system.configurationRevision = self.rev or self.dirtyRev or null;
          })
          # Shared modules
          ./modules/shared/system-packages.nix
          ./modules/shared/fonts.nix
          ./modules/shared/nix-settings.nix
          ./modules/shared/zsh.nix
          ./modules/shared/nixcats.nix
          ./modules/shared/nix-path-priority.nix
          ./modules/shared/cursor.nix
          ./modules/shared/git.nix
          # Darwin-specific modules
          ./modules/darwin/spotlight-applications.nix
          # Host-specific configuration
          ./hosts/mac/configuration.nix
        ];
      };
    };

    # Linux (NixOS) configurations
    nixosConfigurations = {
      "linux" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs self;
          # Pass the builder function instead of pre-building to avoid evaluation-time circular deps
          buildNixCatsForSystem = buildNixCatsForSystem;
        };
        modules = [
          # Set Git commit hash for version tracking
          ({self, ...}: {
            system.configurationRevision = self.rev or self.dirtyRev or null;
          })
          # Shared modules
          ./modules/shared/system-packages.nix
          ./modules/shared/fonts.nix
          ./modules/shared/nix-settings.nix
          ./modules/shared/zsh.nix
          ./modules/shared/nixcats.nix
          ./modules/shared/cursor.nix
          ./modules/shared/git.nix
          # Host-specific configuration
          ./hosts/linux/configuration.nix
        ];
      };
    };

    # Packages for both platforms
    packages.aarch64-darwin.mac = self.darwinConfigurations.mac.system;
    packages.x86_64-linux.linux = self.nixosConfigurations.linux.config.system.build.toplevel;
  } // {
    # nixCats packages merged with existing packages
    packages.aarch64-darwin = (buildNixCatsForSystem "aarch64-darwin") // {
      mac = self.darwinConfigurations.mac.system;
    };
    packages.x86_64-linux = (buildNixCatsForSystem "x86_64-linux") // {
      linux = self.nixosConfigurations.linux.config.system.build.toplevel;
    };
  };
}
