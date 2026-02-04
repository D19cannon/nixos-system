# Shared packages that work on both darwin and Linux

{ pkgs, ... }:

{
  environment.systemPackages = [
    # neovim is provided by nixcats.nix
    pkgs.ansible
    pkgs.bat
    pkgs.code-cursor
    pkgs.commitizen
    pkgs.docker
    pkgs.docker-client
    pkgs.eza
    pkgs.fzf
    pkgs.gh
    pkgs.git
    pkgs.golangci-lint
    pkgs.go
    pkgs.httpie
    pkgs.kubectl
    pkgs.lazygit
    pkgs.lua5_1
    pkgs.luajitPackages.luarocks
    pkgs.mkalias
    pkgs.nodejs
    pkgs.obsidian
    pkgs.pnpm
    pkgs.python3
    pkgs.ripgrep
    pkgs.tig
    pkgs.tldr
    pkgs.tmux
    pkgs.wezterm
    pkgs.zig
    pkgs.zinit
    pkgs.zoxide
    pkgs.zsh
    pkgs.zsh-autocomplete
    pkgs.zsh-autosuggestions
    pkgs.zsh-completions
    pkgs.zsh-history-substring-search
    pkgs.zsh-syntax-highlighting
  ];
}

