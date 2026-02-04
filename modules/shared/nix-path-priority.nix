# PATH configuration to ensure nix-installed packages take precedence over Homebrew
# This module sets up PATH in both /etc/zshrc.local and shellInit

{ config, ... }:

{
  # Ensure nix-installed packages take precedence over Homebrew
  # Create /etc/zshrc.local which is sourced after user's .zshrc
  # This ensures nix paths are prepended even if user's .zshrc modifies PATH
  environment.etc."zshrc.local".text = ''
    # Prepend nix-darwin system profile paths to ensure nix packages take precedence
    # This file is sourced after /etc/zshrc and user's .zshrc
    if [[ ":$PATH:" != *":/run/current-system/sw/bin:"* ]]; then
      export PATH="/run/current-system/sw/bin:$PATH"
    fi
    if [[ ":$PATH:" != *":/nix/var/nix/profiles/default/bin:"* ]]; then
      export PATH="/nix/var/nix/profiles/default/bin:$PATH"
    fi
  '';

  # Also set in shellInit as a fallback
  environment.shellInit = ''
    # Prepend nix-darwin system profile paths to ensure nix packages take precedence
    if [[ ":$PATH:" != *":/run/current-system/sw/bin:"* ]]; then
      export PATH="/run/current-system/sw/bin:$PATH"
    fi
    if [[ ":$PATH:" != *":/nix/var/nix/profiles/default/bin:"* ]]; then
      export PATH="/nix/var/nix/profiles/default/bin:$PATH"
    fi
  '';
}

