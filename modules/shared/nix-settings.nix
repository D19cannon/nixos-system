# Shared nix settings

{ config, ... }:

{
  # Allow unfree packages (e.g., obsidian)
  nixpkgs.config.allowUnfree = true;

  # Necessary for using flakes on this system
  nix.settings.experimental-features = "nix-command flakes";
}

