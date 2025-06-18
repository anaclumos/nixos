{ config, lib, pkgs, ... }:

let onePassPath = "~/.1password/agent.sock";
in {
  # Enable 1Password system-wide
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "sunghyun" ];
  };

  # Browser extension unlocking configuration
  # This allows 1Password to unlock browser extensions automatically
  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        chrome
        chromium
        firefox
        brave
        vivaldi-bin
        google-chrome
      '';
      mode = "0755";
    };
  };

  # 1Password Service Account Token environment variable
  environment.variables = {
    OP_SERVICE_ACCOUNT_TOKEN = "/etc/1password/service-account-token";
    SSH_AUTH_SOCK = onePassPath;
  };

  # Home Manager configuration
  home-manager.users.sunghyun = {
    # 1Password packages (already in packages.nix, but kept here for reference)
    home.packages = with pkgs; [ _1password-gui _1password-cli ];

    # SSH configuration for 1Password SSH agent
    programs.ssh = {
      enable = true;
      forwardAgent = true;
      extraConfig = ''
        Host *
            IdentityAgent ${onePassPath}
      '';
    };


    # Autostart 1Password on login
    xdg.configFile."autostart/1password.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Exec=${pkgs._1password-gui}/bin/1password --silent
      Hidden=false
      NoDisplay=false
      X-GNOME-Autostart-enabled=true
      Name=1Password
      Comment=Password manager and secure wallet
    '';

    # 1Password browser integration helper
    xdg.configFile."1password/1password-bw-integration".text = ''
      # This file enables browser integration
    '';
  };
}
