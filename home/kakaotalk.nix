# KakaoTalk via Bottles - NixOS-level declarative configuration
{ pkgs, ... }:

{
  # Flatpak configuration for Bottles
  services.flatpak.enable = true;
  services.flatpak.remotes = [{
    name = "flathub";
    location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
  }];

  # Install Bottles from Flathub
  services.flatpak.packages = [ "com.usebottles.bottles" ];

  # Allow Bottles to create desktop files and access home directory
  services.flatpak.overrides."com.usebottles.bottles".Context = {
    filesystems = [
      "xdg-data/applications:create"   # write launchers
      "home"                           # reach installer in $HOME
    ];
  };

  # One-shot user unit: create KakaoTalk bottle and install
  systemd.user.services.kakaotalk-init = {
    description = "Initialize KakaoTalk Bottle";
    wantedBy = [ "default.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      set -eu
      STATE="$HOME/.var/app/com.usebottles.bottles/data/bottles/bottles/KakaoTalk"
      INSTALLER="$HOME/installs/KakaoTalk_Setup.exe"
      
      if [ ! -d "$STATE" ]; then
        # Create installs directory if it doesn't exist
        mkdir -p "$HOME/installs"
        
        # Download KakaoTalk installer if it doesn't exist
        if [ ! -f "$INSTALLER" ]; then
          echo "Downloading KakaoTalk installer..."
          ${pkgs.curl}/bin/curl -L -o "$INSTALLER" \
            "https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe"
        fi

        # Create new bottle with minimal Windows environment
        flatpak run --command=bottles-cli com.usebottles.bottles new \
          --bottle-name KakaoTalk --environment software

        # Install KakaoTalk silently
        flatpak run --command=bottles-cli com.usebottles.bottles run \
          -b KakaoTalk \
          -e /host"$INSTALLER" \
          -a "/S"

        # Add KakaoTalk program entry
        flatpak run --command=bottles-cli com.usebottles.bottles add \
          -b KakaoTalk \
          -n "KakaoTalk" \
          -p "C:\\Program Files (x86)\\Kakao\\KakaoTalk\\KakaoTalk.exe"
      fi
    '';
  };
}