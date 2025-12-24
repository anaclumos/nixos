{ ... }:
let
  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    plugin = [ "oh-my-opencode" ];
    # provider = {
    #   openai = {
    #     models = {
    #       "gpt-5.2" = {
    #         options = {
    #           reasoningEffort = "xhigh";
    #           textVerbosity = "medium";
    #           reasoningSummary = "auto";
    #         };
    #       };
    #     };
    #   };
    # };
  };
  ohMyOpencodeConfig = {
    google_auth = true;
    # agents = { Sisyphus = { model = "openai/gpt-5.2"; }; };
  };
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
