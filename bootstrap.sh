#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/anaclumos/nix.git"
TARGET_DIR="$HOME/Desktop/nix"

nix_eval_hw() {
    local result
    if ! result=$(nix --extra-experimental-features "nix-command flakes" eval --impure --raw --expr "
      let
        hwConfig = import /etc/nixos/hardware-configuration.nix {
          config = {};
          lib = import <nixpkgs/lib>;
          pkgs = {};
          modulesPath = toString <nixpkgs/nixos/modules>;
        };
      in $1
    " 2>&1); then
        echo "==> ERROR: nix_eval_hw failed with expression: $1" >&2
        echo "==> Error output: $result" >&2
        exit 1
    fi
    echo "$result"
}

nix_eval_cfg() {
    local result
    if ! result=$(nix --extra-experimental-features "nix-command flakes" eval --impure --raw --expr "
      let
        lib = import <nixpkgs/lib>;
        cfg = import /etc/nixos/configuration.nix {
          config = {};
          lib = lib;
          pkgs = import <nixpkgs> {};
          modulesPath = toString <nixpkgs/nixos/modules>;
        };
      in $1
    " 2>&1); then
        echo "==> ERROR: nix_eval_cfg failed with expression: $1" >&2
        echo "==> Error output: $result" >&2
        exit 1
    fi
    echo "$result"
}

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

echo "==> Detecting swap configuration for hibernation..."
echo "==> DEBUG: Evaluating swapDevices..."
RAW_SWAP=$(nix --extra-experimental-features "nix-command flakes" eval --impure --expr '
  let
    hwConfig = import /etc/nixos/hardware-configuration.nix {
      config = {};
      lib = import <nixpkgs/lib>;
      pkgs = {};
      modulesPath = toString <nixpkgs/nixos/modules>;
    };
  in hwConfig.swapDevices
' 2>&1) || true
echo "==> DEBUG: Raw swapDevices = $RAW_SWAP"

SWAP_DEVICE=$(nix_eval_hw 'if hwConfig.swapDevices == [] then "" else (builtins.head hwConfig.swapDevices).device or ""')
echo "==> DEBUG: SWAP_DEVICE = '$SWAP_DEVICE'"

if [ -n "$SWAP_DEVICE" ]; then
    echo "==> Found swap partition: $SWAP_DEVICE"

    SWAP_LUKS_NAME=$(basename "$SWAP_DEVICE")
    SWAP_RAW_UUID="${SWAP_LUKS_NAME#luks-}"

    LUKS_DEVICE=$(nix_eval_cfg "cfg.boot.initrd.luks.devices.\"$SWAP_LUKS_NAME\".device or \"\"")

    if [ -n "$LUKS_DEVICE" ]; then
        echo "==> Found swap LUKS device: $SWAP_LUKS_NAME"

        sed -i '/# Unlock swap partition for hibernation/d' "$TARGET_DIR/configuration.nix"
        sed -i '/boot.initrd.luks.devices."luks-.*".device/d' "$TARGET_DIR/configuration.nix"

        sed -i "/boot.kernelPackages = pkgs.linuxPackages_latest;/a\\
  boot.initrd.luks.devices.\"$SWAP_LUKS_NAME\".device = \"/dev/disk/by-uuid/$SWAP_RAW_UUID\";" "$TARGET_DIR/configuration.nix"
        echo "==> Updated configuration.nix with swap LUKS device"
    else
        echo "==> Swap partition is not encrypted, no LUKS setup needed"
    fi

    sed -i "s|boot.resumeDevice = .*|boot.resumeDevice = \"$SWAP_DEVICE\";|" "$TARGET_DIR/system/hibernation.nix"
    echo "==> Updated hibernation.nix resume device to $SWAP_DEVICE"
else
    echo "==> No swap partition found, will use swapfile configuration"
fi

echo "==> Building and switching to new NixOS configuration (first pass)..."
sudo nixos-rebuild switch --flake "$TARGET_DIR#framework"

echo "==> Updating swap configuration for hibernation..."
if [ -z "$SWAP_DEVICE" ] && [ -f /var/lib/swapfile ]; then
    SWAP_OFFSET=$(sudo filefrag -v /var/lib/swapfile | awk 'NR==4 {print $4}' | sed 's/\.\.//')
    if [ -n "$SWAP_OFFSET" ]; then
        sed -i "s/resume_offset=[0-9]*/resume_offset=$SWAP_OFFSET/" "$TARGET_DIR/system/hibernation.nix"
        echo "==> Updated resume_offset to $SWAP_OFFSET"
        echo "==> Rebuilding with correct hibernation offset..."
        sudo nixos-rebuild switch --flake "$TARGET_DIR#framework"
    else
        echo "==> WARNING: Could not determine swap offset"
    fi
elif [ -n "$SWAP_DEVICE" ]; then
    echo "==> Using swap partition for hibernation (no offset needed)"
else
    echo "==> Swapfile not yet created, hibernation offset will need to be set after reboot"
fi

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
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +20
sudo nix-store --gc

echo "==> Bootstrap complete!"
echo "==> Your NixOS configuration is now at: $TARGET_DIR"
echo "==> Rebooting in 5 seconds..."
sleep 5
sudo reboot
