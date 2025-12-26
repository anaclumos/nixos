#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/anaclumos/nix.git"
TARGET_DIR="$HOME/Desktop/nix"

echo "==> NixOS Bootstrap Script"
echo "==> This will set up your NixOS configuration"

mkdir -p "$HOME/Desktop"
cd "$HOME/Desktop"

echo "==> Cloning configuration repository..."
if [ -d "$TARGET_DIR" ]; then
    echo "==> Directory $TARGET_DIR already exists, pulling latest..."
    nix-shell -p git --run "cd $TARGET_DIR && git pull"
else
    nix-shell -p git --run "git clone $REPO_URL $TARGET_DIR"
fi

cd "$TARGET_DIR"

echo "==> Formatting Nix files..."
nix-shell -p nixfmt-classic --run "nixfmt **/*.nix"

echo "==> Copying hardware-configuration.nix from /etc/nixos..."
if [ -f /etc/nixos/hardware-configuration.nix ]; then
    cp /etc/nixos/hardware-configuration.nix "$TARGET_DIR/hardware-configuration.nix"
    echo "==> hardware-configuration.nix copied successfully"
else
    echo "==> WARNING: /etc/nixos/hardware-configuration.nix not found"
    echo "==> You may need to run: nixos-generate-config --show-hardware-config > hardware-configuration.nix"
fi

echo "==> Building and switching to new NixOS configuration..."
sudo nixos-rebuild switch --flake "$TARGET_DIR#framework"

echo "==> Updating Framework firmware via fwupd..."
sudo fwupdmgr refresh --force || true
sudo fwupdmgr get-updates || true
sudo fwupdmgr update -y || echo "==> No firmware updates available or update requires reboot"

echo "==> Running final build..."
cd "$TARGET_DIR"
nixfmt **/*.nix
nix-channel --update
nix --extra-experimental-features 'nix-command flakes' flake update
sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#framework --impure
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +100
sudo nix-store --gc

echo "==> Bootstrap complete!"
echo "==> Your NixOS configuration is now at: $TARGET_DIR"
echo "==> Rebooting in 5 seconds..."
sleep 5
sudo reboot
