# NixOS Configuration Guidelines

DO NOT EDIT FILES OR RUN COMMANDS IMPERATIVELY. ALL "SETTINGS" OR "FIXES" SHOULD BE DECLARED IN NIX AND ONLY SOLVED BY REBUILDING NIX. YOU ARE ONLY ALLOWED TO RUN HOME MANAGER REBUILD.

## Commands
- **Rebuild system**: `sudo nixos-rebuild switch`
- **Format code**: `find . -name "*.nix" -type f | xargs nixfmt`
- **Update flake**: `sudo nix flake update`
- **All-in-one rebuild**: Format + update flake + rebuild system
  ```
  find . -name "*.nix" -type f | xargs nixfmt && sudo nix flake update && sudo nixos-rebuild switch
  ```

## Code Style
- Use `nixfmt-classic` for consistent formatting
- Keep configuration modular (hardware vs system config)
- Follow standard NixOS module patterns
- Use descriptive option names in configuration
- Organize related configurations together
- Comment non-obvious configuration choices
- Use flakes for reproducible builds
- Validate configuration before applying: `nixos-rebuild build`
- Test configuration in VM when making major changes: `nixos-rebuild build-vm`

## Repository Structure
- `configuration.nix`: Main system configuration (system-wide settings)
- `hardware-configuration.nix`: Hardware-specific settings
- `flake.nix`: Package sources and system definition
- `home.nix`: User-specific configuration managed by Home Manager

## Architecture
- System-wide settings belong in `configuration.nix`
- User-specific settings belong in `home.nix` (managed by Home Manager)
- All changes must be made through configuration files and applied with `nixos-rebuild`
- No imperative changes (editing dotfiles directly)
