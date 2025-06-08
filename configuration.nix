{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.fwupd.enable = true;
  services.fprintd.enable = true;

  networking.hostName = "cho";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n = { defaultLocale = "en_US.UTF-8"; };

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

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.pantheon.enable = true;
  };

  services.pantheon = {
    apps.enable = true;
    contractor.enable = true;
  };

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

