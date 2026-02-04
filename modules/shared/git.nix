# Git configuration
# Manages Git settings based on ~/.dotfiles/.gitconfig

{ pkgs, config, ... }:

let
  # Git config content
  gitConfig = pkgs.writeText "gitconfig" ''
# This is Git's per-user configuration file.
[user]
	name = <username>
	email = <useremail>@<domain>
[core]
	ignorecase = false
[rebase]
	autosquash = true
[fetch]
	prune = true
[pull]
	rebase = true
[push]
	autoSetupRemote = true
[filter "lfs"]
	clean = git-lfs clean -- %f
	smudge = git-lfs smudge -- %f
	process = git-lfs filter-process
	required = true
[init]
	defaultBranch = main
  '';
in
{
  # Activation script to set up Git configuration
  system.activationScripts.gitConfig = ''
    echo "setting up Git configuration..." >&2

    # Copy gitconfig to home directory
    if [ -f "${gitConfig}" ]; then
      cp -f "${gitConfig}" "$HOME/.gitconfig"
      echo "Git configuration file set up" >&2
    fi
  '';

  # Activation script for Git login
  system.activationScripts.gitLogin = ''
    echo "Setting up Git login..." >&2

    # Check if already authenticated with GitHub CLI
    if gh auth status &>/dev/null; then
      echo "GitHub CLI already authenticated" >&2
      gh auth login
    else
      echo "GitHub CLI login required" >&2
      gh auth login
    fi
  '';
}
