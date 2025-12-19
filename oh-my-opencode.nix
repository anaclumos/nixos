{ ... }:
let
  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    plugin = [ "oh-my-opencode" ];
  };
  ohMyOpencodeConfig = { google_auth = true; };
in {
  xdg.configFile."opencode/opencode.json" = {
    force = true;
    text = builtins.toJSON opencodeConfig + "\n";
  };

  xdg.configFile."opencode/oh-my-opencode.json" = {
    force = true;
    text = builtins.toJSON ohMyOpencodeConfig + "\n";
  };
}
