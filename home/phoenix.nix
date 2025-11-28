{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    beam.packages.erlang_27.erlang
    beam.packages.erlang_27.elixir
    beam.packages.erlang_27.rebar3

    tailwindcss
    esbuild

    inotify-tools
  ];
  home.sessionVariables = {
    MIX_ESBUILD_PATH = "${pkgs.esbuild}/bin/esbuild";
    MIX_TAILWIND_PATH = "${pkgs.tailwindcss}/bin/tailwindcss";
  };
  home.shellAliases = {
    phx-new = "mix phx.new";
    phx-server = "mix phx.server";
    phx-routes = "mix phx.routes";
    mix-deps = "mix deps.get";
    mix-migrate = "mix ecto.migrate";
    mix-setup = "mix setup";
  };
}
