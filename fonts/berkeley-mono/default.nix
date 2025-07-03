{ config, pkgs, ... }:

let berkeleyMono = pkgs.callPackage ./berkeley-mono.nix { };
in {
  fonts = {
    fontDir.enable = true;
    packages = [ berkeleyMono ];

    fontconfig = {
      enable = true;
      defaultFonts.monospace = [ "Berkeley Mono" ];
    };
  };
}
