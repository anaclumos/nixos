{ config, pkgs, lib, ... }:

{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          # Caps as Hyper when held; maximize window on tap (Super+Up)
          capslock = "overload(hyper, macro(M-up))";
        };

        # Hyper layer applies C-A-S-M to keys by default.
        # Provide a couple of window management tweaks under Hyper.
        "hyper:C-A-S-M" = {
          left = "M-left";
          right = "M-right";
          enter = "macro(M-S-end M-up)";
        };
      };
    };
  };
}

