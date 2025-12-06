{ config, pkgs, ... }:

{
  # Enable ROCm support
  hardware.graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ];

  environment.systemPackages = with pkgs; [ rocmPackages.rocminfo clinfo ];

  systemd.tmpfiles.rules =
    [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];

  environment.variables = {
    # ROCm 6.0+ might need this for consumer cards (RDNA 3 / 3.5)
    # Strix Point (Radeon 890M) is RDNA 3.5, which is compatible with gfx1100 (RDNA 3)
    HSA_OVERRIDE_GFX_VERSION = "11.0.0";
  };
}
