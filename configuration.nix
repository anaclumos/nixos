{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.fwupd.enable = true;
  services.fprintd.enable = true;

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [
          "*"
        ]; # what goes into the [id] section, here we select all keyboard
        # extraConfig = builtins.readFile /home/deftdawg/source/meta-mac/keyd/kde-mac-keyboard.conf; # use includes when debugging, easier to edit in vscode
        extraConfig = ''
          # Use Alt as "command" key and Super/Windows as "alt" key
          [main]
          # Bind Alt keys to trigger the 'meta_mac' layer (acting as Command)
          leftalt = layer(meta_mac)

          # Remap Super/Windows keys to act as Alt
          leftmeta = leftalt
          rightmeta = rightalt

          # Remap Caps Lock to left meta
          capslock = leftmeta

          # Map left control to left meta + function key layer
          leftcontrol = layer(meta_fn)

          # By default meta_mac = Ctrl+<key>, except for mappings below
          [meta_mac:C]
          # Use alternate Copy/Cut/Paste bindings from Windows that won't conflict with Ctrl+C used to break terminal apps
          # Copy (works everywhere (incl. vscode term) except Konsole)
          c = C-insert
          # Paste
          v = S-insert
          # Cut
          x = S-delete

          # FIXME: for Konsole, we must create a shortcut in our default Konsole profile to bind Copy's Alternate to 'Ctrl+Ins'

          # Switch directly to an open tab (e.g., Firefox, VS Code)
          1 = A-1
          2 = A-2
          3 = A-3
          4 = A-4
          5 = A-5
          6 = A-6
          7 = A-7
          8 = A-8
          9 = A-9

          # Move cursor to the beginning of the line
          left = home
          # Move cursor to the end of the line
          right = end

          # As soon as 'tab' is pressed (but not yet released), switch to the 'app_switch_state' overlay
          tab = swapm(app_switch_state, A-tab)

          [app_switch_state:A]
          # Being in this state holds 'Alt' down allowing us to switch back and forth with tab or arrow presses

          [meta_fn:M]
          # Left control + function key layer - map arrow keys to workspace switching
          left = M-home
          right = M-end
          up = M-pageup
          down = M-pagedown
        '';
      };
    };
  };

  networking.hostName = "cho";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ hangul ];
    };
  };

  fonts.packages = with pkgs; [ pretendard ];
  fonts.fontconfig = {
    defaultFonts = {
      sansSerif = [ "Pretendard" ];
      serif = [ "Pretendard" ];
    };
    localConf = ''
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
  };

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  users.users.sunghyun = {
    isNormalUser = true;
    description = "Sunghyun Cho";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "docker" "npm" "sudo" "command-not-found" ];
    };

    shellAliases = {
      rebuild =
        "cd ~/Desktop/nixos && nixfmt *.nix && nix-channel --update && nix --extra-experimental-features 'nix-command flakes' flake update && sudo nixos-rebuild switch --flake .#cho";
      nixgit = ''git commit -m "$(date +"%Y-%m-%d")" -a && git push'';
      qqqq = "cd ~/Desktop/extracranial && bun run save";
      x = "exit";
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [ git zsh ];

  system.stateVersion = "25.05";
}

