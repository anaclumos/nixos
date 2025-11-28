{ config, pkgs, lib, ... }:

{
  virtualisation.docker.enable = true;
  users.users.sunghyun.extraGroups = [ "docker" ];
}
