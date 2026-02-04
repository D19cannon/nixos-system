# Shared zsh configuration for both darwin and Linux

{ pkgs, config, ... }:

{
  # Enable zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
  };

  # Shell aliases
  environment.shellAliases = {
    cat = "bat";
    cd = "z";
    c = "clear";
    ls = "eza --icons=always";
    ll = "ls -la";
    gs = "git status";
    gl = "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
    t = "tig";
    gcz = "cz commit";
    hgf = "huggingface-cli";
    sphp = "brew-php-switcher";
    py = "python3";
  };

  # Main zsh configuration (using interactiveShellInit for user-specific config)
  environment.interactiveShellInit = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # History configuration
      HISTSIZE=5000
      HISTFILE=~/.zsh_history
      SAVEHIST=5000
      HISTDUP=erase

      # Set history options
      setopt appendhistory
      setopt sharehistory
      setopt hist_ignore_space
      setopt hist_ignore_all_dups
      setopt hist_save_no_dups
      setopt hist_ignore_dups
      setopt hist_find_no_dups

      # Set the directory we want to store zinit and plugins
      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"

      # Download Zinit, if it's not there yet
      if [ ! -d "$ZINIT_HOME" ]; then
         mkdir -p "$(dirname $ZINIT_HOME)"
         git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      fi

      # Source/Load zinit
      source "''${ZINIT_HOME}/zinit.zsh"

      # Add in Powerlevel10k
      zinit ice depth=1; zinit light romkatv/powerlevel10k

      # Add in zsh plugins
      zinit light zsh-users/zsh-syntax-highlighting
      zinit light zsh-users/zsh-completions
      zinit light zsh-users/zsh-autosuggestions
      zinit light Aloxaf/fzf-tab

      # Add in snippets
      zinit snippet OMZP::1password
      zinit snippet OMZP::ansible
      zinit snippet OMZP::brew
      zinit snippet OMZP::colorize
      zinit snippet OMZP::command-not-found
      zinit snippet OMZP::docker
      zinit snippet OMZP::git
      zinit snippet OMZP::golang
      zinit snippet OMZP::history
      zinit snippet OMZP::sudo
      zinit snippet OMZP::kubectl
      zinit snippet OMZP::kubectx
      zinit snippet OMZP::nmap
      zinit snippet OMZP::npm
      zinit snippet OMZP::nvm
      zinit snippet OMZP::tldr
      zinit snippet OMZP::tmux
      zinit snippet OMZP::ubuntu
      zinit snippet OMZP::vi-mode
      zinit snippet OMZP::wp-cli
      zinit snippet OMZP::yarn

      zinit light-mode depth"1" for \
        @zdharma-continuum/zinit-annex-binary-symlink \
        @zdharma-continuum/zinit-annex-bin-gem-node \
        @zdharma-continuum/zinit-annex-default-ice \
        @zdharma-continuum/zinit-annex-patch-dl \
        @zdharma-continuum/zinit-annex-readurl
      zinit default-ice --quiet as'null' from"gh-r" lbin'!' lucid nocompile completions
      zinit lbin'!**/eza' for @eza-community/eza

      # Load completions
      autoload -Uz compinit && compinit

      # Completion styling
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

      zinit cdreplay -q

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
      typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
      typeset -g POWERLEVEL9K_DIR_BACKGROUND=0

      # Keybindings
      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      bindkey '^[w' kill-region

      # Shell integrations
      eval "$(${pkgs.fzf}/bin/fzf --zsh)"
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"

      # Environment variables and PATH
      ${if pkgs.stdenv.isDarwin then ''
        if [[ -f "/opt/homebrew/bin/brew" ]] then
          # If you're using macOS, you'll want this enabled
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
      '' else ""}

      # pnpm
      export PNPM_HOME="$HOME/Library/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac

      # php
      export PATH=$PATH:~/.composer/vendor/bin
      ${if pkgs.stdenv.isDarwin then ''
        # java
        export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
      '' else ""}

      # LM Studio CLI (lms)
      export PATH="$PATH:$HOME/.lmstudio/bin"

      # console-ninja
      PATH=~/.console-ninja/.bin:$PATH

      # magic completion (if installed)
      if command -v magic &> /dev/null; then
        eval "$(magic completion --shell zsh)"
      fi

      function reload(){
        source ~/.zshrc
      }
  '';
}

