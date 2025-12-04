#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/anaclumos/nix.git"
TARGET_DIR="$HOME/Documents/nix"

echo "==> NixOS Bootstrap Script"
echo "==> This will set up your NixOS configuration"

mkdir -p "$HOME/Documents"
cd "$HOME/Documents"

echo "==> Cloning configuration repository..."
if [ -d "$TARGET_DIR" ]; then
    echo "==> Directory $TARGET_DIR already exists, pulling latest..."
    nix-shell -p git --run "cd $TARGET_DIR && git pull"
else
    nix-shell -p git --run "git clone $REPO_URL $TARGET_DIR"
fi

cd "$TARGET_DIR"

echo "==> Copying hardware-configuration.nix from /etc/nixos..."
if [ -f /etc/nixos/hardware-configuration.nix ]; then
    cp /etc/nixos/hardware-configuration.nix "$TARGET_DIR/hardware-configuration.nix"
    echo "==> hardware-configuration.nix copied successfully"
else
    echo "==> WARNING: /etc/nixos/hardware-configuration.nix not found"
    echo "==> You may need to run: nixos-generate-config --show-hardware-config > hardware-configuration.nix"
fi

echo "==> Detecting swap configuration for hibernation..."
# Check if installer configured a swap partition in swapDevices
# Extract swap device from hardware-configuration.nix (under swapDevices section)
SWAP_DEVICE=$(awk '/swapDevices/,/\];/' /etc/nixos/hardware-configuration.nix | grep 'device = ' | head -1 | sed 's/.*device = "\([^"]*\)".*/\1/')

if [ -n "$SWAP_DEVICE" ] && [ "$SWAP_DEVICE" != "" ]; then
    echo "==> Found swap partition: $SWAP_DEVICE"

    # Extract UUID from the swap device path (e.g., /dev/mapper/luks-UUID -> luks-UUID)
    SWAP_LUKS_NAME=$(basename "$SWAP_DEVICE")

    # Check if installer's configuration.nix has the LUKS unlock for swap
    if grep -q "$SWAP_LUKS_NAME" /etc/nixos/configuration.nix 2>/dev/null; then
        # Extract the raw UUID (without luks- prefix)
        SWAP_RAW_UUID="${SWAP_LUKS_NAME#luks-}"
        echo "==> Found swap LUKS device: $SWAP_LUKS_NAME"

        # Update configuration.nix with swap LUKS unlock
        # Remove any existing swap LUKS lines first (clean slate)
        sed -i '/# Unlock swap partition for hibernation/d' "$TARGET_DIR/configuration.nix"
        sed -i '/boot.initrd.luks.devices."luks-.*".device/d' "$TARGET_DIR/configuration.nix"

        # Find the line with boot.kernelPackages and add swap LUKS after it
        sed -i "/boot.kernelPackages = pkgs.linuxPackages_latest;/a\\  # Unlock swap partition for hibernation\\
  boot.initrd.luks.devices.\"$SWAP_LUKS_NAME\".device = \"/dev/disk/by-uuid/$SWAP_RAW_UUID\";" "$TARGET_DIR/configuration.nix"
        echo "==> Updated configuration.nix with swap LUKS device"

        # Update hibernation.nix with the swap device as resume device
        sed -i "s|boot.resumeDevice = .*|boot.resumeDevice = \"$SWAP_DEVICE\";|" "$TARGET_DIR/system/hibernation.nix"
        echo "==> Updated hibernation.nix resume device to $SWAP_DEVICE"
    else
        echo "==> Swap LUKS device not found in configuration.nix, skipping LUKS setup"
    fi
else
    echo "==> No swap partition found, will use swapfile configuration"
fi

echo "==> Building and switching to new NixOS configuration (first pass)..."
sudo nixos-rebuild switch --flake "$TARGET_DIR#framework"

echo "==> Updating swap configuration for hibernation..."
# Check if using swapfile (created after first build) or swap partition
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
