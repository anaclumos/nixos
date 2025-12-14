{ lib, pkgs, inputs, username, ... }:
let
  homeDir = "/home/${username}";
  onePassAgent = "${homeDir}/.1password/agent.sock";

  developmentTools = with pkgs; [
    nodejs
    nodePackages.pnpm
    nodePackages.vercel
    bun
    nixfmt-classic
    claude-code
    code-cursor
    vscode
    hub
    gh
    scc
    ffmpeg-full
    whois
    lefthook
    unzip
    zip
    act
    terraform
    biome
    vscode-extensions.biomejs.biome
    argocd
    k9s
    kubectl
    moon
    git
    zsh
    cacert
    uv
    ruff
    comma
    mariadb
    pkg-config
    nix-index
    codex
    lsof
    azure-cli
    azure-storage-azcopy
    gemini-cli
    tmux
    cmake
    gcc
    gnumake
    wget
    podman-compose
    _1password-cli
    libheif
    libsndfile
    btop
    tectonic
    tex-fmt
    trayscale
    jq
    opencode
  ];

  games = with pkgs; [
    dolphin-emu
    bottles
    (lutris.override { extraPkgs = pkgs: [ pkgs.libnghttp2 pkgs.winetricks ]; })
    wineWowPackages.staging
    winetricks
    vulkan-tools
    dxvk
  ];

  applications = with pkgs; [
    slack
    teams-for-linux
    obsidian
    google-chrome
    firefox
    spotify
    _1password-gui
    ookla-speedtest
    geekbench
    expressvpn
    caffeine-ng
    zoom-us
    pngcrush
    imagemagick
    pngquant
    logseq
    pods
    sqlitebrowser
    timewall
    signal-desktop
    telegram-desktop
    inputs.kakaotalk.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  gnomeTools = with pkgs; [ refine ];
  systemTools = with pkgs; [ xclip wmctrl xdotool pciutils nvme-cli ];

  cloudTools = with pkgs;
    [
      (google-cloud-sdk.withExtraComponents
        [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    ];

  tb = pkgs.thunderbird;
  tb-ui = pkgs.writeShellScriptBin "thunderbird-ui" ''
    systemctl --user stop thunderbird-headless.service 2>/dev/null || true
    "${tb}/bin/thunderbird" "$@"
    systemctl --user start thunderbird-headless.service
  '';
  tb-headless-wrapper =
    pkgs.writeShellScriptBin "thunderbird-headless-wrapper" ''
      set -euo pipefail
      export DISPLAY=:0
      export WAYLAND_DISPLAY=wayland-0
      export XDG_RUNTIME_DIR="/run/user/$(id -u)"

      # Launch the UI from a transient unit so stopping this headless service
      # (which thunderbird-ui does) does not kill the launcher mid-run.
      launch_ui() {
        if systemctl --user is-active --quiet thunderbird-open-from-notification.service; then
          return
        fi
        systemd-run --user --collect --quiet --unit=thunderbird-open-from-notification ${tb-ui}/bin/thunderbird-ui || true
      }

      ${pkgs.dbus}/bin/dbus-monitor --session "interface='org.freedesktop.Notifications',member='ActionInvoked'" |
      while read -r line; do
        if echo "$line" | grep -q "ActionInvoked"; then
          launch_ui
        fi
      done &
      MONITOR_PID=$!

      "${tb}/bin/thunderbird" --headless
      kill $MONITOR_PID 2>/dev/null || true
    '';

  fontAliases = [
    "Helvetica"
    "Helvetica Neue"
    "Arial"
    "-apple-system"
    "BlinkMacSystemFont"
    "Ubuntu"
    "noto-sans"
    "malgun gothic"
    "Apple SD Gothic Neo"
    "AppleSDGothicNeo"
    "Noto Sans TC"
    "Noto Sans JP"
    "Noto Sans KR"
    "Noto Sans"
    "Roboto"
    "Tahoma"
    "맑은 고딕"
    "맑은고딕"
    "MalgunGothic"
    "돋움"
  ];
in {
  dconf.enable = true;
  home.username = username;
  home.homeDirectory = homeDir;
  home.stateVersion = "25.11";
  services.mpris-proxy.enable = true;

  home.language = {
    base = "en_US.UTF-8";
    address = "en_US.UTF-8";
    measurement = "en_US.UTF-8";
    monetary = "en_US.UTF-8";
    time = "en_US.UTF-8";
  };

  home.packages = lib.unique (developmentTools ++ games ++ applications
    ++ gnomeTools ++ systemTools ++ cloudTools ++ [ tb tb-ui ] ++ (with pkgs; [
      pantheon.elementary-icon-theme
      hicolor-icon-theme
      adwaita-icon-theme
      whitesur-icon-theme

      gnomeExtensions.unite
      gnomeExtensions.clipboard-history
      gnomeExtensions.appindicator
      gnomeExtensions.kimpanel
      gnomeExtensions.dock-from-dash
    ]));

  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fastfetch = {
      enable = true;
      settings = {
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          "uptime"
          "packages"
          "shell"
          "display"
          "de"
          "wm"
          "wmtheme"
          "theme"
          "icons"
          "font"
          "cursor"
          "terminal"
          "terminalfont"
          "cpu"
          "gpu"
          "memory"
          "swap"
          "disk"
          "battery"
          "poweradapter"
          "locale"
          "break"
          "colors"
        ];
      };
    };
    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        auto_sync = true;
        sync_frequency = "1h";
        search_mode = "fuzzy";
        filter_mode = "global";
        update_check = false;
      };
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" "podman" "npm" "sudo" "command-not-found" ];
      };
      initContent = ''
        fastfetch && if [ "$(pwd)" = "${homeDir}" ]; then cd ~/Documents; fi
      '';
      shellAliases = {
        build =
          "cd ~/Documents/nix && nixfmt **/*.nix && nix-channel --update && nix --extra-experimental-features 'nix-command flakes' flake update && sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#framework --impure && ngc";
        nixgit = ''
          cd ~/Documents/nix && git commit -m "$(date +"%Y-%m-%d")" -a && git push'';
        ec = "expressvpn connect";
        ed = "expressvpn disconnect";
        x = "exit";
        oo = "hub browse";
        zz = "code ~/Documents/nix";
        ss = "source ~/.zshrc";
        cc = "code .";
        sha =
          "git push && echo Done in $(git rev-parse HEAD) | xclip -selection clipboard";
        emptyfolder = "find . -type d -empty -delete";
        npm = "bun";
        npx = "bunx";
        chat = "codex --yolo -c model_reasoning_effort='high'";
        ngc =
          "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +20 && sudo nix-store --gc";
        airdrop =
          "cd ~/Screenshots && sudo tailscale file cp *.png iphone-17-pro: && rm *.png";
      };
    };
    git = {
      enable = true;
      signing = {
        signByDefault = true;
        key =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGaWDMcfAJMbWDorZP8z1beEAz+fjLb+VFqFm8hkAlpt";
      };
      settings = {
        user = {
          name = "Sunghyun Cho";
          email = "hey@cho.sh";
        };
        core = { editor = "cursor --wait"; };
        credential = { helper = "${lib.getExe pkgs.gh} auth git-credential"; };
        gpg = { format = "ssh"; };
        "gpg \"ssh\"" = {
          program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        };
        commit = { gpgsign = true; };
      };
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          forwardAgent = true;
          identityAgent = onePassAgent;
        };
      };
    };
  };

  xdg.configFile."fcitx5/config" = {
    force = true;
    text = ''
      [Hotkey]
      TriggerKeys=
      EnumerateWithTriggerKeys=True
      AltTriggerKeys=
      EnumerateForwardKeys=
      EnumerateBackwardKeys=
      EnumerateSkipFirst=False
      EnumerateGroupForwardKeys=
      EnumerateGroupBackwardKeys=
      PrevPage=
      NextPage=
      PrevCandidate=
      NextCandidate=
      TogglePreedit=
      ModifierOnlyKeyTimeout=250
      [Hotkey/ActivateKeys]
      0=Control+Control_R
      [Hotkey/DeactivateKeys]
      0=Control+Control_L
      [Behavior]
      ActiveByDefault=False
      resetStateWhenFocusIn=No
      ShareInputState=No
      PreeditEnabledByDefault=True
      ShowInputMethodInformation=True
      showInputMethodInformationWhenFocusIn=False
      CompactInputMethodInformation=True
      ShowFirstInputMethodInformation=True
      DefaultPageSize=5
      OverrideXkbOption=False
      CustomXkbOption=
      EnabledAddons=
      DisabledAddons=
      PreloadInputMethod=True
      AllowInputMethodForPassword=False
      ShowPreeditForPassword=False
      AutoSavePeriod=30
    '';
  };
  xdg.configFile."fcitx5/addon/x11frontend.conf".text = ''
    [Addon]
    Enabled=True
  '';
  xdg.configFile."fcitx5/profile" = {
    force = true;
    text = ''
      [Groups/0]
      Name=Default
      Default Layout=us
      DefaultIM=hangul
      [Groups/0/Items/0]
      Name=keyboard-us
      Layout=
      [Groups/0/Items/1]
      Name=hangul
      Layout=
      [GroupOrder]
      0=Default
    '';
  };
  xdg.configFile."fcitx5/conf/hangul.conf" = {
    force = true;
    text = ''
      Keyboard=Dubeolsik
      AutoReorder=True
      WordCommit=False
      HanjaMode=False
      [HanjaModeToggleKey]
      0=Hangul_Hanja
      1=F9
      [PrevPage]
      0=Up
      [NextPage]
      0=Down
      [PrevCandidate]
      0=Shift+Tab
      [NextCandidate]
      0=Tab
    '';
  };
  xdg.configFile."fcitx5/conf/notifications.conf" = {
    force = true;
    text = ''
      HiddenNotifications=
    '';
  };
  xdg.configFile."fcitx5/conf/xim.conf" = {
    force = true;
    text = ''
      UseOnTheSpot=True
    '';
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

  systemd.user.services.timewall = {
    Unit = {
      Description = "Timewall - Dynamic HEIF wallpaper daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.timewall}/bin/timewall set --daemon '${
          ./wallpaper/solar-gradient.heic
        }'";
      Restart = "always";
      RestartSec = "10";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };

  xdg.configFile."timewall/config.toml" = {
    text = ''
      [location]
      lat = 37.5665
      lon = 126.9780
    '';
    force = true;
  };

  systemd.user.services.thunderbird-headless = {
    Unit = {
      Description =
        "Thunderbird headless (background mail checks + notifications)";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${tb-headless-wrapper}/bin/thunderbird-headless-wrapper";
      Restart = "on-failure";
      Environment = [ "DISPLAY=:0" "WAYLAND_DISPLAY=wayland-0" ];
    };
    Install = { WantedBy = [ "default.target" ]; };
  };
  xdg.desktopEntries.thunderbird = {
    name = "Thunderbird";
    exec = "thunderbird-ui %u";
    terminal = false;
    icon = "thunderbird";
    type = "Application";
    categories = [ "Network" "Email" ];
    startupNotify = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
      font-name = "Pretendard 12";
      document-font-name = "Pretendard 12";
      monospace-font-name = "Berkeley Mono 12";
      icon-theme = "WhiteSur";
      cursor-theme = "elementary";
      clock-show-weekday = true;
      clock-format = "12h";
      enable-hot-corners = false;
      enable-animations = false;
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Pretendard Bold 12";
    };
    "org/gnome/system/locale" = { region = "en_US.UTF-8"; };
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "google-chrome.desktop"
        "thunderbird.desktop"
        "spotify.desktop"
        "org.gnome.Calendar.desktop"
        "code.desktop"
        "obsidian.desktop"
        "slack.desktop"
        "kakaotalk.desktop"
      ];
      enabled-extensions = [
        "unite@hardpixel.eu"
        "clipboard-history@alexsaveau.dev"
        "appindicatorsupport@rgcjonas.gmail.com"
        "kimpanel@kde.org"
        "dock-from-dash@fthx"
      ];
    };

    "org/gnome/shell/extensions/clipboard-history" = {
      toggle-menu = [ "<Control>g" ];
    };
    "org/gnome/shell/extensions/unite" = {
      app-menu-ellipsize-mode = "start";
      desktop-name-text = "성현";
      extend-left-box = false;
      hide-activities-button = "always";
      hide-window-titlebars = "never";
      notifications-position = "center";
      reduce-panel-spacing = true;
      show-appmenu-button = true;
      show-window-buttons = "never";
      show-window-title = "always";
      use-activities-text = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/spotlight/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/jira/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/1password/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/dark-mode/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/kakaotalk/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/spotlight" =
      {
        name = "GNOME Overview";
        command =
          "bash -c 'dbus-send --session --dest=org.gnome.Shell --type=method_call /org/gnome/Shell org.freedesktop.DBus.Properties.Set string:org.gnome.Shell string:OverviewActive variant:boolean:true'";
        binding = "<Ctrl>space";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/jira" = {
      name = "Open Jira";
      command = "xdg-open https://lunit.atlassian.net/jira/core/projects/INCL2";
      binding = "<Ctrl><Alt><Super><Shift>i";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock" = {
      name = "Lock Screen";
      command =
        "dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock";
      binding = "<Ctrl>l";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/1password" =
      {
        name = "1Password Quick Access";
        command = "1password --quick-access";
        binding = "<Ctrl><Shift>space";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/dark-mode" =
      {
        name = "Toggle Dark Mode";
        command =
          "bash -c 'current=$(gsettings get org.gnome.desktop.interface color-scheme); if [[ \"$current\" == '''prefer-dark''' ]]; then gsettings set org.gnome.desktop.interface color-scheme ''''default'''; else gsettings set org.gnome.desktop.interface color-scheme ''''prefer-dark'''; fi'";
        binding = "<Ctrl><Alt><Super><Shift>grave";
      };
  };
}
