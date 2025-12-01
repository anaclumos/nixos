{ config, lib, pkgs, ... }:

let onePassPath = "~/.1password/agent.sock";
in {
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "sunghyun" ];
  };

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        google-chrome
        google-chrome-stable
        .google-chrome-wrapped
        .zen-wrapped
        zen
      '';
      mode = "0755";
    };
  };

  environment.variables = {
    OP_SERVICE_ACCOUNT_TOKEN = "/etc/1password/service-account-token";
    SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
  };

  home-manager.users.sunghyun = {
    home.packages = with pkgs; [ _1password-gui _1password-cli ];

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          forwardAgent = true;
          identityAgent = onePassPath;
        };
      };
    };

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

    xdg.configFile."1password/1password-bw-integration".text = "";
  };
}
