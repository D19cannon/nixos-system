# nixCats-nvim configuration
# Based on https://github.com/devluixos/luix_nix_config

{ nixCats, nixpkgs, luaPath }:

let
  nixCatsUtils = nixCats.utils;

  nixCatsCategoryDefinitions = { pkgs, ... }: {
    startupPlugins.general = [
      pkgs.vimPlugins.telescope-nvim
      pkgs.vimPlugins.telescope-fzf-native-nvim
      pkgs.vimPlugins.nvim-web-devicons
      pkgs.vimPlugins.gitsigns-nvim
      pkgs.vimPlugins.lazygit-nvim
      pkgs.vimPlugins.indent-blankline-nvim
      pkgs.vimPlugins.lualine-nvim
      pkgs.vimPlugins.alpha-nvim
      pkgs.vimPlugins.tokyonight-nvim
      pkgs.vimPlugins.nvim-lspconfig
      pkgs.vimPlugins.mason-nvim
      pkgs.vimPlugins.mason-lspconfig-nvim
    ];
    optionalPlugins.none = [];
    lspsAndRuntimeDeps.general = [
      pkgs.nodePackages.typescript-language-server
      pkgs.nodePackages.vscode-json-languageserver
      pkgs.vscode-langservers-extracted
      pkgs.lua-language-server
      pkgs.nixd
    ];
  };

  nixCatsPackageDefinitions = {
    nvim = { pkgs, ... }: {
      # Don't set aliases to avoid potential symlink loops
      # The package will be available as 'nvim' by default
      settings = { };
      categories = { general = true; };
    };
  };

  nixCatsDefaultPackageName = "nvim";

  buildNixCatsForSystem = system: let
    pkgs = import nixpkgs { inherit system; };
    nixCatsBuilder = nixCatsUtils.baseBuilder luaPath {
      inherit nixpkgs system;
    } nixCatsCategoryDefinitions nixCatsPackageDefinitions;
    nixCatsDefaultPackage = nixCatsBuilder nixCatsDefaultPackageName;
  in
    nixCatsUtils.mkAllWithDefault nixCatsDefaultPackage;
in
{
  inherit buildNixCatsForSystem;
}

