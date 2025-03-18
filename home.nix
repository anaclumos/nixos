{ config, pkgs, lib, ... }:
{
  home.username = "sunghyuncho";
  home.homeDirectory = "/home/sunghyuncho";
  
  # Keyboard remapping configuration
  home.keyboard = {
    layout = "us";
    options = [
      "caps:super"     # Caps Lock → Super
      "ctrl:swap_lwin_lctl"  # Left Win/Cmd → Left Ctrl
    ];
  };

  # X11 key bindings for terminal copy/paste and input method switching
  xsession.windowManager.command = ''
    ${pkgs.xorg.xmodmap}/bin/xmodmap - <<EOF
      keycode 133 = Control_L
      keycode 134 = Control_L
      add Control = Control_L
    EOF

    # Configure IBus
    export GTK_IM_MODULE=ibus
    export XMODIFIERS=@im=ibus
    export QT_IM_MODULE=ibus
    ${pkgs.ibus}/bin/ibus-daemon -drx
  '';

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
    };
    # Terminal keybindings for GNOME Terminal
    "org/gnome/terminal/legacy/keybindings" = {
      copy = "<Primary>c";
      paste = "<Primary>v";
    };
    # IBus preferences
    "desktop/ibus/general" = {
      preload-engines = ["hangul"];
      use-system-keyboard-layout = true;
    };
    "desktop/ibus/general/hotkey" = {
      triggers = ["Super_L" "Super_R"];  # Left and Right Command keys
    };
  };
  
  home.packages = with pkgs; [
    git
    vscode
    google-chrome
    gitAndTools.hub
    spotify
    asdf-vm
    _1password-cli
    _1password-gui
    gh
    (lib.hiPrio windsurf)
    nodejs
    pnpm
    slack
    ibus
    ibus-engines.hangul
  ];
  
  programs.home-manager.enable = true;  
  programs.atuin.enable = false;
  
  # Zsh configuration with oh-my-zsh
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "npm"
        "sudo"
        "command-not-found"
      ];
      theme = "robbyrussell";
    };
  };
  
  programs.git = {
    enable = true;
    userName = "Sunghyun Cho";
    userEmail = "hey@cho.sh";
  };
  
  home.stateVersion = "24.11";
}
