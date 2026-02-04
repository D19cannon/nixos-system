# NixOS Flakes Post-Install Script Documentation

## Overview

This document compiles resources for executing scripts post-install with terminal user inputs in NixOS flakes, particularly for login/setup purposes.

## Key Documentation Resources

### 1. Activation Scripts (Primary Mechanism)

**Official Documentation:**
- **NixOS Manual - Activation Scripts**:
  - GitHub: https://github.com/NixOS/nixpkgs/blob/master/nixos/doc/manual/development/activation-script.section.md
  - This is the primary documentation for activation scripts in NixOS

**Implementation Reference:**
- **Activation Script Module**:
  - https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/activation/activation-script.nix
  - Shows how activation scripts are implemented in NixOS

### 2. Flakes Documentation

**NixOS Wiki - Flakes:**
- https://nixos.wiki/wiki/Flakes
- Comprehensive guide to using flakes with NixOS

**Flake Outputs:**
- https://nixos-unified.org/guide/outputs
- Information about flake outputs including activation apps

### 3. Community Discussions

**NixOS Discourse:**
- Post-install hooks discussion: https://discourse.nixos.org/t/postinstall-or-hook/33994
- Community examples and approaches

## Implementation Approaches

### Approach 1: Using `system.activationScripts` (NixOS)

Activation scripts run during `nixos-rebuild switch`. They can execute shell scripts that prompt for user input.

**Example Structure:**
```nix
{
  system.activationScripts.myPostInstall = ''
    # Check if this is first run
    if [ ! -f /var/lib/myapp/.initialized ]; then
      echo "First-time setup..."
      read -p "Enter username: " username
      read -sp "Enter password: " password
      echo
      # Process login...
      touch /var/lib/myapp/.initialized
    fi
  '';
}
```

**Important Notes:**
- Activation scripts run during system activation (requires root)
- They execute in a controlled environment
- For interactive input, ensure the script runs in a context where stdin is available
- Consider using `systemd` services for more complex interactive workflows

### Approach 2: Using `system.activationScripts` (nix-darwin)

For macOS with nix-darwin (as in your current setup):

```nix
{
  system.activationScripts.myPostInstall = ''
    echo "Running post-install setup..." >&2
    # Interactive script here
    read -p "Enter credentials: " input
    # Process input...
  '';
}
```

### Approach 3: Systemd Service for First Boot

For more complex interactive setups, consider a systemd service that runs once:

```nix
{
  systemd.services.first-boot-setup = {
    description = "First boot interactive setup";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.writeShellScript "first-boot" ''
        if [ ! -f /var/lib/first-boot-complete ]; then
          # Interactive setup here
          read -p "Username: " username
          # Login logic...
          touch /var/lib/first-boot-complete
        fi
      ''}";
    };
  };
}
```

### Approach 4: Flake Apps

You can create a flake app that runs interactively:

```nix
{
  apps.default = {
    type = "app";
    program = "${pkgs.writeShellScript "setup" ''
      # Interactive setup script
      read -p "Enter login credentials: " creds
      # Process...
    ''}";
  };
}
```

Then run: `nix run .#setup`

## Important Considerations

1. **Activation Script Context**: Activation scripts run during system rebuilds. For truly interactive input, ensure:
   - The script runs in a context with access to stdin
   - Consider using `systemd` services for user-facing interactions
   - Activation scripts may not always have a TTY available

2. **First Boot Detection**: Use flag files to detect first run:
   ```bash
   if [ ! -f /var/lib/myapp/.initialized ]; then
     # First boot logic
   fi
   ```

3. **User Input in Shell Scripts**:
   - `read -p "Prompt: " variable` - for visible input
   - `read -sp "Password: " variable` - for hidden password input
   - `read -t 30 -p "Prompt: " variable` - with timeout

4. **Security**:
   - Never store passwords in plain text
   - Use secure credential storage mechanisms
   - Consider using `pass` or other password managers

## Current Setup Reference

Your current configuration already uses activation scripts:
- `modules/shared/cursor.nix` - Uses `system.activationScripts.cursorConfig`
- `hosts/mac/configuration.nix` - Uses `system.activationScripts.addUserToAdmin`
- `modules/shared/git.nix` - Uses `system.activationScripts.gitConfig`

These can serve as templates for adding interactive post-install scripts.

## Recommended Reading Order

1. Start with the NixOS Manual activation script section
2. Review the activation-script.nix module source
3. Check NixOS Discourse for community examples
4. Review your existing activation scripts as examples
5. Consider systemd services for complex interactive workflows

## Additional Resources

- **NixOS Manual**: https://nixos.org/manual/nixos/
- **nix-darwin Manual**: https://daiderd.com/nix-darwin/manual/
- **NixOS Wiki**: https://nixos.wiki/
- **NixOS Discourse**: https://discourse.nixos.org/

