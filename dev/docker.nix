{ config, pkgs, lib, ... }:

{
  # Docker
  virtualisation.docker.enable = true;

  # Add user to docker group
  users.users.sunghyun.extraGroups = [ "docker" ];
}