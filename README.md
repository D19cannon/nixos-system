# Symfoo Multi-Platform Nix Configuration

Multi-platform nix configuration supporting both macOS (darwin) and Linux (NixOS) systems.

## Structure

```text
symfoo-nix/
├── flake.nix                    # Main flake with both darwinConfigurations and nixosConfigurations
├── hosts/
│   ├── mac/
│   │   └── configuration.nix    # macOS-specific configuration
│   └── linux/
│       └── configuration.nix   # Linux-specific configuration
└── modules/
    ├── shared/                  # Shared modules for both platforms
    │   ├── packages.nix         # Common packages (neovim, tmux)
    │   ├── fonts.nix            # Common fonts
    │   └── nix-settings.nix     # Common nix settings
    ├── darwin/                  # Darwin-specific modules
    │   └── spotlight-applications.nix
    └── nix-path-priority.nix   # PATH priority (works on both)
```

## Nix Installation

Install Lix on macOS or Ubuntu using a single command:

```bash
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```

This will install a complete Lix setup on your system.

## Building and Switching

### macOS (darwin)

#### Build macOS configuration

Build the darwin configuration without applying it:

```bash
nix build .#mac
```

Or using darwin-rebuild:

```bash
darwin-rebuild build --flake '.#mac'
```

#### Switch to macOS configuration

Apply the configuration to your system (requires sudo for system activation):

```bash
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake '.#mac'
```

Or if `darwin-rebuild` is available in your PATH:

```bash
darwin-rebuild switch --flake '.#mac'
```

### Linux (NixOS)

#### Build Linux configuration

Build the NixOS configuration without applying it:

```bash
nix build .#nixosConfigurations.linux.config.system.build.toplevel
```

Or using nixos-rebuild:

```bash
sudo nixos-rebuild build --flake '.#linux'
```

#### Switch to Linux configuration

Apply the configuration to your system:

```bash
sudo nixos-rebuild switch --flake '.#linux'
```

## Configuration

### Shared Configuration

The following modules are shared between both platforms:

- **Packages**: neovim, tmux
- **Fonts**: Fira Code, JetBrains Mono, Droid Sans Mono
- **Nix Settings**: Flakes enabled, experimental features

### macOS-Specific

- Homebrew management via nix-homebrew
- Spotlight integration for nix-installed applications
- PATH priority to ensure nix packages take precedence
- macOS-specific packages: alacritty, obsidian, mkalias

### Linux-Specific

- NixOS system configuration
- Linux-specific packages (add as needed)

## Notes

- The quotes around `'.#mac'` or `'.#linux'` are required in zsh to prevent glob expansion
- The `--extra-experimental-features` flag must be passed to `nix` before `run` when using `nix run`
- All module files must be git-tracked for nix flakes to include them
