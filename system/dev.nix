{ config, pkgs, lib, ... }: {
  # Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # Lunit environment variables
  environment.sessionVariables = rec {
    INCL_SERVER_HOST = "34.47.100.100";
    INCL_DJANGO_PORT = "30000";
    INCL_GIN_PORT = "30010";
    INCL_RECORD_SERVER_URL =
      "http://${INCL_SERVER_HOST}:${INCL_GIN_PORT}/api/v1";
    INCL_BACKEND_SERVER_URL =
      "http://${INCL_SERVER_HOST}:${INCL_DJANGO_PORT}/api/v1";
    INCL_DATA_ROOT = "./data_root";
  };
}
