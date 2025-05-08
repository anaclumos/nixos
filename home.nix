# home.nix
# Home Manager main configuration file

{ config, pkgs, inputs, ... }:

{
  #-----------------------------------------------------------------------
  # HOME MANAGER CORE CONFIGURATION
  #-----------------------------------------------------------------------

  # Import external modules
  imports = [
    # 1Password shell plugins integration
    inputs._1password-shell-plugins.hmModules.default
  ];

  # Basic user configuration
  home.username = "sunghyuncho";
  home.homeDirectory = "/home/sunghyuncho";

  # This value determines the Home Manager release that your
  # configuration is compatible with. DO NOT CHANGE after initial setup.
  home.stateVersion = "24.11";

  # Enable Home Manager itself
  programs.home-manager.enable = true;

  #-----------------------------------------------------------------------
  # CURSOR & DESKTOP THEME
  #-----------------------------------------------------------------------

  # Configure cursor theme to fix white box cursor issue
  home.pointerCursor = {
    gtk.enable = true; # Enable for GTK applications
    x11.enable = true; # Enable for X11 applications
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita"; # Use Adwaita cursor theme
    size = 24; # Set cursor size to 24px
  };

  # Configure GNOME desktop environment settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-format = "12h"; # Use 12-hour clock format
      enable-animations = false; # Disable interface animations
      icon-theme = "Adwaita"; # Set icon theme to ensure proper icon display
    };

    # Configure window preferences and hide title bar
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      titlebar-font =
        "Pretendard 0"; # Setting font size to 0 effectively hides the title bar
    };

    # Disable all animations in mutter (window manager)
    "org/gnome/mutter" = {
      experimental-features = [ ];
      animate-appicon-hover = false;
      edge-tiling = false;
      # Enable hot corners to show dash/app grid when hitting bottom of screen
      edge-profiles = [ "scale" "none" "none" "none" ];
    };

    # Additional animation disabling and extension configuration
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disable-extension-version-validation = true;
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
      ];
    };

    # Dash to Dock configuration
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "BOTTOM";
      intellihide = true;
      autohide = true;
      show-apps-at-top = false;
      hot-keys = false;
      pressure-threshold = 100.0; # Lower value = less pressure needed to reveal
    };
  };

  #-----------------------------------------------------------------------
  # USER PACKAGES
  #-----------------------------------------------------------------------

  home.packages = with pkgs; [
    # Development tools
    git # Version control
    gitAndTools.hub # GitHub CLI tool
    asdf-vm # Runtime version manager
    nodejs # Node.js runtime
    nodePackages.pnpm # Fast Node package manager
    bun # JavaScript runtime, bundler, transpiler and package manager
    nixfmt-classic # NixOS formatter for config files
    claude-code # Anthropic Claude Code AI assistant

    # Communication and productivity
    slack # Team communication
    obsidian # Knowledge base and note-taking

    # Input methods
    ibus # Input method framework
    ibus-engines.hangul # Korean input support

    # Web browsers and utilities
    google-chrome # Web browser
    windsurf # Web browser (alternative)

    # System utilities
    adwaita-icon-theme # Cursor and icon theme
    gnome.adwaita-icon-theme # Complete GNOME icon theme
    hicolor-icon-theme # Fallback icon theme
    adguardhome # Network-wide ad blocking
    xclip # Command line clipboard tool
    fastfetch # System information tool
    tailscale # Tailscale VPN client

    # GNOME extensions
    gnomeExtensions.dash-to-dock # Dock with configurable behavior
    gnomeExtensions.system-monitor # System monitor for CPU/RAM/Network stats
    gnomeExtensions.vitals # System monitoring in top bar

    # Gaming
    steam # Gaming platform
  ];

  #-----------------------------------------------------------------------
  # 1PASSWORD CONFIGURATION
  #-----------------------------------------------------------------------

  # Configure 1Password shell plugins integration
  programs._1password-shell-plugins = {
    enable = true;
    plugins = with pkgs; [
      gh # GitHub CLI integration
      awscli2 # AWS CLI integration
    ];
  };

  #-----------------------------------------------------------------------
  # ZSH SHELL CONFIGURATION
  #-----------------------------------------------------------------------

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true; # Enable command suggestions
    enableCompletion = true; # Enable tab completion

    # Oh My Zsh framework configuration
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell"; # Use robbyrussell theme
      plugins = [
        "git" # Git integration
        "docker" # Docker commands
        "npm" # NPM commands
        "sudo" # Sudo plugin
        "command-not-found" # Suggest packages for missing commands
      ];
    };

    # Custom shell aliases
    shellAliases = {
      # Rebuild NixOS system with updates (requires sudo)
      rebuild =
        "cd ~/etc/nixos && nixfmt *.nix && nix-channel --update && nix flake update && sudo nixos-rebuild switch --flake .#spaceship";

      # Build NixOS system without switching (no sudo required)
      build = "cd ~/etc/nixos && nixos-rebuild build --flake .#spaceship";

      # Quick git commit and push with timestamp
      nixgit = ''git commit -m "$(date +"%Y-%m-%d")" -a && git push'';

      # Format all files for LLM (Large Language Model) input
      llm = ''
        find . -type f ! -path "*/.git/*" ! -name "*.lock*" ! -name "*lock.*" -exec grep -Iq . {} \; -and -exec sh -c 'echo -e "### $(basename $1)\n\n\`\`\`\n$(cat $1)\n\`\`\`\n\n"' sh {} \; | xclip -selection clipboard'';
    };

    # Additional shell initialization
    initContent = ''
      # Source 1Password plugins if they exist
      if [ -f ~/.config/op/plugins.sh ]; then
        source ~/.config/op/plugins.sh
      fi

      # Ensure 1Password SSH agent is used
      export SSH_AUTH_SOCK=~/.1password/agent.sock

      # Add SSH identities to 1Password agent
      if [ -z "$(ssh-add -l 2>/dev/null)" ]; then
        op signin
      fi

      # Run fastfetch on terminal start for system information display
      command -v fastfetch >/dev/null 2>&1 && fastfetch
    '';
  };

  #-----------------------------------------------------------------------
  # SSH CONFIGURATION
  #-----------------------------------------------------------------------

  programs.ssh = {
    enable = true;
    # Use 1Password as SSH agent
    extraConfig = ''
      IdentityAgent ~/.1password/agent.sock
      AddKeysToAgent yes
    '';
  };

  #-----------------------------------------------------------------------
  # GIT CONFIGURATION
  #-----------------------------------------------------------------------

  programs.git = {
    enable = true;
    userName = "Sunghyun Cho";
    userEmail = "hey@cho.sh";

    # Configure SSH key signing
    signing = {
      key =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGaWDMcfAJMbWDorZP8z1beEAz+fjLb+VFqFm8hkAlpt";
      signByDefault = true;
    };

    # Additional Git configuration
    extraConfig = {
      # Use SSH for signing
      gpg.format = "ssh";
      # Use 1Password SSH signing
      gpg.ssh.program = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
      # Sign all commits by default
      commit.gpgsign = true;
    };
  };

  #-----------------------------------------------------------------------
  # FONT CONFIGURATION
  #-----------------------------------------------------------------------

  # Enable fontconfig
  fonts.fontconfig.enable = true;

  # Update icon cache after system changes
  home.activation.updateGTKIconCache = {
    after = [ "writeBoundary" "linkGeneration" ];
    before = [ ];
    data = "gtk-update-icon-cache -qtf ~/.local/share/icons/* || true";
  };

  # Configure font substitutions to use Pretendard font
  xdg.configFile."fontconfig/conf.d/99-pretendard-substitutions.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <!-- Replace Helvetica with Pretendard -->
      <match target="pattern">
        <test qual="any" name="family">
          <string>Helvetica</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <!-- Replace Helvetica Neue with Pretendard -->
      <match target="pattern">
        <test qual="any" name="family">
          <string>Helvetica Neue</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <!-- Replace Arial with Pretendard -->
      <match target="pattern">
        <test qual="any" name="family">
          <string>Arial</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <!-- Replace -apple-system with Pretendard -->
      <match target="pattern">
        <test qual="any" name="family">
          <string>-apple-system</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <!-- Replace BlinkMacSystemFont with Pretendard -->
      <match target="pattern">
        <test qual="any" name="family">
          <string>BlinkMacSystemFont</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <!-- Replace Ubuntu with Pretendard -->
      <match target="pattern">
        <test qual="any" name="family">
          <string>Ubuntu</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>
    </fontconfig>
  '';

}
