# configuration.nix
# Main system configuration file

{ config, pkgs, lib, ... }: {
  #-----------------------------------------------------------------------
  # IMPORTS
  #-----------------------------------------------------------------------

  imports = [
    # Hardware-specific configuration
    ./hardware-configuration.nix
  ];

  #-----------------------------------------------------------------------
  # BOOT CONFIGURATION
  #-----------------------------------------------------------------------

  # Use systemd-boot as the bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #-----------------------------------------------------------------------
  # SECURITY SETTINGS
  #-----------------------------------------------------------------------

  # Enable PolicyKit for privileged operations
  security.polkit.enable = true;

  # Enable RealtimeKit for real-time scheduling
  security.rtkit.enable = true;

  #-----------------------------------------------------------------------
  # NETWORKING
  #-----------------------------------------------------------------------

  # Set the hostname
  networking.hostName = "spaceship";

  # Firewall configuration
  networking.firewall = {
    enable = true;
    # Enable the firewall
    allowedTCPPorts = [ 22 ];
    # Allow Tailscale traffic
    trustedInterfaces = [ "tailscale0" ];
    # Allow traffic from internal trusted networks
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  #-----------------------------------------------------------------------
  # NIX PACKAGE MANAGER SETTINGS
  #-----------------------------------------------------------------------

  # Enable experimental features (required for flakes)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow installation of unfree packages
  nixpkgs.config.allowUnfree = true;

  #-----------------------------------------------------------------------
  # LOCALIZATION
  #-----------------------------------------------------------------------

  # Set timezone
  time.timeZone = "Asia/Seoul";

  # Configure language and input method
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      type = "ibus";
      enable = true;
      # Enable Korean input (Hangul)
      ibus.engines = with pkgs.ibus-engines; [ hangul ];
    };
  };

  #-----------------------------------------------------------------------
  # VIRTUALIZATION & CONTAINERS
  #-----------------------------------------------------------------------

  # Enable Docker support
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  #-----------------------------------------------------------------------
  # DESKTOP ENVIRONMENT & DISPLAY
  #-----------------------------------------------------------------------

  services.xserver = {
    # Enable the X server
    enable = true;

    # Configure GDM as the display manager (login screen)
    displayManager.gdm.enable = true;

    # Use GNOME desktop environment
    desktopManager.gnome.enable = true;

    # Configure keyboard layout
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  #-----------------------------------------------------------------------
  # INPUT DEVICE CONFIGURATION
  #-----------------------------------------------------------------------

  services.libinput = {
    enable = true;

    # Touchpad settings for laptop
    touchpad = {
      naturalScrolling = true; # Natural scrolling (like macOS)
      scrollMethod = "twofinger"; # Two-finger scrolling
      accelSpeed = "0.7"; # Pointer acceleration
      accelProfile = "adaptive"; # Adaptive acceleration profile
    };

    # Mouse settings
    mouse = {
      accelProfile = "flat"; # Disable mouse acceleration (better for precision)
      middleEmulation = false; # Disable middle button emulation
    };
  };

  #-----------------------------------------------------------------------
  # AUDIO CONFIGURATION
  #-----------------------------------------------------------------------

  # Disable PulseAudio (replaced by PipeWire)
  services.pulseaudio.enable = false;

  # Enable PipeWire audio system
  services.pipewire = {
    enable = true;
    alsa.enable = true; # ALSA compatibility
    alsa.support32Bit = true; # Support for 32-bit applications
    pulse.enable = true; # PulseAudio compatibility
  };

  #-----------------------------------------------------------------------
  # OTHER SERVICES
  #-----------------------------------------------------------------------

  # Enable printing support
  services.printing.enable = true;

  # Enable Tailscale VPN
  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = null; # Will use interactive login
    extraUpFlags = [ "--ssh" ];
  };

  # Make NetworkManager respect Tailscale routes
  networking.networkmanager = { enable = true; };

  #-----------------------------------------------------------------------
  # USER CONFIGURATION
  #-----------------------------------------------------------------------

  users.users.sunghyuncho = {
    isNormalUser = true;
    description = "성현";
    # Add user to important groups
    extraGroups = [
      "networkmanager" # Manage network settings
      "wheel" # Sudo access
      "docker" # Docker access
    ];
    shell = pkgs.zsh; # Use zsh as default shell
  };

  #-----------------------------------------------------------------------
  # SHELL CONFIGURATION
  #-----------------------------------------------------------------------

  # Enable zsh system-wide
  programs.zsh.enable = true;

  #-----------------------------------------------------------------------
  # APPLICATION CONFIGURATION
  #-----------------------------------------------------------------------

  # Enable 1Password CLI
  programs._1password = { enable = true; };

  # Enable 1Password GUI with polkit integration
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "sunghyuncho" ];
  };

  # Disable OpenSSH's built-in SSH agent (using 1Password instead)
  programs.ssh.startAgent = false;

  # Start 1Password automatically
  environment.etc = {
    "xdg/autostart/1password.desktop" = {
      source = "${pkgs._1password-gui}/share/applications/1password.desktop";
      mode = "0644";
    };
  };

  #-----------------------------------------------------------------------
  # SYSTEM PACKAGES
  #-----------------------------------------------------------------------

  # Install system-wide packages
  environment.systemPackages = with pkgs; [
    # Shell and terminal utilities
    zsh
    zsh-autosuggestions

    # Development tools
    git

    # Password management
    _1password-gui
    _1password-cli

    # Docker tools
    docker-compose
  ];

  #-----------------------------------------------------------------------
  # FONT CONFIGURATION
  #-----------------------------------------------------------------------

  # Install fonts
  fonts.packages = with pkgs; [ pretendard ];

  # Set default fonts
  fonts.fontconfig.defaultFonts = {
    serif = [ "Pretendard" ];
    sansSerif = [ "Pretendard" ];
  };

  #-----------------------------------------------------------------------
  # ENVIRONMENT VARIABLES
  #-----------------------------------------------------------------------

  environment.sessionVariables = {
    PNPM_HOME = "/root/.local/share/pnpm";
    PATH = [ "\${PNPM_HOME}" ];
  };

  #-----------------------------------------------------------------------
  # SYSTEM STATE VERSION
  #-----------------------------------------------------------------------

  # This value determines the NixOS release with which your system is to be
  # compatible. DO NOT CHANGE after initial setup.
  system.stateVersion = "24.11";
}
