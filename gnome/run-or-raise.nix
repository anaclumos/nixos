{ config, pkgs, lib, ... }:

{
  # Run or Raise extension configuration
  home.file.".config/run-or-raise/shortcuts.conf".text = ''
    # Migrated shortcuts from gnome-shortcuts.nix to Run or Raise Extension
    # To reload shortcuts, turn the extension off and on
    
    # =================
    # Application shortcuts (Run or raise form)
    # =================
    
    # Browser - Google Chrome (Hyper+j)
    <Ctrl><Alt><Super><Shift>j,google-chrome-stable,google-chrome.Google-chrome,
    
    # Notes - Obsidian (Hyper+o)
    <Ctrl><Alt><Super><Shift>o,obsidian,obsidian.Obsidian,
    
    # Code Editor - Cursor (Hyper+;)
    <Ctrl><Alt><Super><Shift>semicolon,cursor,cursor.Cursor,
    
    # Terminal - kgx (Hyper+')
    <Ctrl><Alt><Super><Shift>apostrophe,kgx,kgx.Kgx,
    
    # Team Chat - Slack (Hyper+n)
    <Ctrl><Alt><Super><Shift>n,slack,Slack,
    
    # Chat - KakaoTalk (Hyper+m)
    <Ctrl><Alt><Super><Shift>m,kakaotalk,KakaoTalk,
    
    # Mail - Thunderbird (Hyper+h)
    <Ctrl><Alt><Super><Shift>h,thunderbird,thunderbird.Thunderbird,
    
    # Music - YouTube Music (Hyper+k)
    <Ctrl><Alt><Super><Shift>k,youtube-music,com.github.th_ch.youtube_music.com.github.th_ch.youtube_music,
    
    # =================
    # Run only form (commands and shortcuts)
    # =================
    
    # GNOME Overview (Spotlight replacement - Ctrl+Space)
    <Ctrl>space,dbus-send --session --dest=org.gnome.Shell --type=method_call /org/gnome/Shell org.freedesktop.DBus.Properties.Set string:org.gnome.Shell string:OverviewActive variant:boolean:true
    
    # Linear - Open in browser (Hyper+i)
    <Ctrl><Alt><Super><Shift>i,xdg-open https://linear.app
    
    # Lock Screen (Ctrl+l)
    <Ctrl>l,dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock
    
    # 1Password Quick Access (Ctrl+Shift+Space)
    <Ctrl><Shift>space,1password --quick-access
    
    # Toggle Dark Mode (Hyper+`)
    <Ctrl><Alt><Super><Shift>grave,bash -c 'current=$(gsettings get org.gnome.desktop.interface color-scheme); if [[ "$current" == "'"'"'prefer-dark'"'"'" ]]; then gsettings set org.gnome.desktop.interface color-scheme "'"'"'default'"'"'"; else gsettings set org.gnome.desktop.interface color-scheme "'"'"'prefer-dark'"'"'"; fi'
  '';
  
  # Enable the Run or Raise extension (assuming it's installed via gnome-extensions)
  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = lib.mkDefault [
        "run-or-raise@edvard.cz"
      ];
    };
  };
}