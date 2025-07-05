{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # BEAM toolchain (OTP 27 / Elixir 1.17)
    beam.packages.erlang_27.erlang
    beam.packages.erlang_27.elixir
    beam.packages.erlang_27.rebar3

    # Phoenix generator & asset helpers
    tailwindcss
    esbuild

    # Runtime extras for Phoenix development
    inotify-tools
  ];

  # Environment variables for Phoenix development
  home.sessionVariables = {
    # Make Phoenix asset tasks use the Nix-installed binaries
    MIX_ESBUILD_PATH = "${pkgs.esbuild}/bin/esbuild";
    MIX_TAILWIND_PATH = "${pkgs.tailwindcss}/bin/tailwindcss";
  };

  # Shell aliases for Phoenix development
  home.shellAliases = {
    # Common Phoenix/Mix commands
    phx-new = "mix phx.new";
    phx-server = "mix phx.server";
    phx-routes = "mix phx.routes";
    mix-deps = "mix deps.get";
    mix-migrate = "mix ecto.migrate";
    mix-setup = "mix setup";
  };
}