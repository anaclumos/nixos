{ config, pkgs, ... }:
let
  user = config.modules.user.name;
  userHome = "/home/${user}";
  onePassAgent = "${userHome}/.1password/agent.sock";
  lunitSessionVariables = rec {
    INCL_SERVER_HOST = "34.47.100.100";
    INCL_DJANGO_PORT = "30000";
    INCL_GIN_PORT = "30010";
    INCL_RECORD_SERVER_URL =
      "http://${INCL_SERVER_HOST}:${INCL_GIN_PORT}/api/v1";
    INCL_BACKEND_SERVER_URL =
      "http://${INCL_SERVER_HOST}:${INCL_DJANGO_PORT}/api/v1";
    INCL_DATA_ROOT = "./data_root";
  };
in {
  programs.zsh.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  environment.sessionVariables = lunitSessionVariables;

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        extraConfig = ''
          [main]
          capslock = overload(hyper, macro(A-f10))
          f10 = leftmeta
          leftalt = layer(mac_command)
          rightalt = rightcontrol
          leftmeta = layer(mac_alt)
          rightmeta = layer(mac_alt)
          leftcontrol = layer(mac_control)
          rightcontrol = layer(mac_control)
          [mac_command:C]
          c = C-insert
          v = S-insert
          x = S-delete
          [ = A-left
          ] = A-right
          tab = swapm(app_switch_state, A-tab)
          left = home
          up = pageup
          right = end
          down = pagedown
          [mac_command+shift]
          c = C-S-c
          [app_switch_state:A]
          backspace = C-backspace
          [mac_alt:A]
          left = C-left
          right = C-right
          backspace = C-backspace
          [mac_control:C]
          left = M-pageup
          right = M-pagedown
          [hyper:C-A-S-M]
          left = M-left
          right = M-right
          f = M-1
          h = M-3
          j = M-2
          k = M-4
          l = M-5
          semicolon = M-6
          o = M-7
          n = M-8
          m = M-9
          enter = macro(M-S-end M-up)
        '';
      };
    };
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ user ];
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
    SSH_AUTH_SOCK = onePassAgent;
  };
}
