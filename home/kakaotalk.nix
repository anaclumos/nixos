# KakaoTalk via Bottles - Home Manager configuration
{ config, pkgs, lib, ... }:

{
  # Ensure Flatpak packages are available
  home.packages = with pkgs; [
    flatpak
  ];

  # Create systemd user service for KakaoTalk setup
  systemd.user.services.kakaotalk-setup = {
    Unit = {
      Description = "Setup KakaoTalk in Bottles";
      After = [ "graphical-session.target" ];
      ConditionPathExists = "!/home/sunghyun/.var/app/com.usebottles.bottles/data/bottles/bottles/KakaoTalk";
    };
    
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.writeShellScript "kakaotalk-setup" ''
        set -e
        
        # Wait for Flatpak to be ready
        sleep 5
        
        # Install Bottles if not already installed
        if ! flatpak list | grep -q com.usebottles.bottles; then
          echo "Installing Bottles..."
          flatpak install -y flathub com.usebottles.bottles
        fi
        
        # Create directories
        mkdir -p "$HOME/installs"
        mkdir -p "$HOME/.local/share/applications"
        
        # Download KakaoTalk installer if needed
        INSTALLER="$HOME/installs/KakaoTalk_Setup.exe"
        if [ ! -f "$INSTALLER" ]; then
          echo "Downloading KakaoTalk installer..."
          ${pkgs.curl}/bin/curl -L -o "$INSTALLER" \
            "https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe"
        fi
        
        # Create the bottle
        echo "Creating KakaoTalk bottle..."
        flatpak run --command=bottles-cli com.usebottles.bottles new \
          --bottle-name KakaoTalk \
          --environment software || true
        
        # Wait a bit for bottle creation
        sleep 5
        
        # Install KakaoTalk
        echo "Installing KakaoTalk..."
        flatpak run --command=bottles-cli com.usebottles.bottles run \
          -b KakaoTalk \
          -e "$INSTALLER" \
          -a "/S" || true
        
        # Wait for installation
        sleep 10
        
        # Add program to Bottles
        flatpak run --command=bottles-cli com.usebottles.bottles add \
          -b KakaoTalk \
          -n "KakaoTalk" \
          -p "C:\\Program Files (x86)\\Kakao\\KakaoTalk\\KakaoTalk.exe" || true
        
        echo "KakaoTalk setup completed!"
      ''}";
    };
    
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Create desktop file for KakaoTalk
  xdg.desktopEntries.kakaotalk = {
    name = "KakaoTalk";
    comment = "KakaoTalk Messenger";
    icon = "com.usebottles.bottles";
    exec = ''flatpak run --command=bottles-cli com.usebottles.bottles run -b KakaoTalk -p "KakaoTalk"'';
    terminal = false;
    categories = [ "Network" "Chat" "InstantMessaging" ];
    mimeType = [ ];
  };

  # Create a manual refresh script
  home.file.".local/bin/refresh-kakaotalk" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      systemctl --user restart kakaotalk-setup
      echo "KakaoTalk refresh initiated. Check journalctl --user -u kakaotalk-setup for logs."
    '';
  };

  # Add Flatpak overrides for Bottles
  xdg.configFile."flatpak/overrides/com.usebottles.bottles".text = ''
    [Context]
    filesystems=xdg-data/applications:create;home
  '';
}