{
  #-----------------------------------------------------------------------
  # NIXOS FLAKE CONFIGURATION
  #-----------------------------------------------------------------------

  # Description of this NixOS configuration
  description = "Sunghyun Cho's NixOS Configuration";

  #-----------------------------------------------------------------------
  # FLAKE INPUTS (DEPENDENCIES)
  #-----------------------------------------------------------------------

  inputs = {
    # NixOS unstable channel - provides package definitions
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager - for managing user environment
    home-manager = {
      url = "github:nix-community/home-manager";
      # Use the same nixpkgs as the main system
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 1Password shell plugins for CLI integration
    _1password-shell-plugins.url = "github:1Password/shell-plugins";
  };

  #-----------------------------------------------------------------------
  # FLAKE OUTPUTS
  #-----------------------------------------------------------------------

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    # Define a system configuration named "spaceship"
    nixosConfigurations.spaceship = nixpkgs.lib.nixosSystem {
      # Set system architecture
      system = "x86_64-linux";

      # List of configuration modules to include
      modules = [
        # Main system configuration
        ./configuration.nix

        # Include Home Manager module
        home-manager.nixosModules.home-manager

        # Home Manager configuration
        {
          # Use the global package set from NixOS
          home-manager.useGlobalPkgs = true;

          # Install user packages through the system's package manager
          home-manager.useUserPackages = true;

          # Pass flake inputs to Home Manager
          home-manager.extraSpecialArgs = { inherit inputs; };

          # User-specific Home Manager configuration
          home-manager.users.sunghyuncho = import ./home.nix;

          # Backup extension for files modified by Home Manager
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
