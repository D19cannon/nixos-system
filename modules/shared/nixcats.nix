# nixCats Neovim configuration
# Based on https://github.com/devluixos/luix_nix_config

{ inputs, pkgs, config, buildNixCatsForSystem, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  # Build nixCats packages lazily during module evaluation (not during flake evaluation)
  nixCatsPackages = buildNixCatsForSystem system;
  nixcatsPackage =
    if nixCatsPackages ? nvim then nixCatsPackages.nvim else nixCatsPackages.default;
in
{
  # Add nixCats Neovim package to system packages (replacing regular neovim)
  environment.systemPackages = [
    nixcatsPackage
  ];

  # Set Neovim as default editor
  environment.variables.EDITOR = "nvim";
  environment.variables.VISUAL = "nvim";

  # Create aliases for vi and vim to point to nvim
  environment.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };
}

