# nix

```bash
#!/usr/bin/env bash

set -euo pipefail

# Script to Wipe /dev/sda and Install NixOS from Flake "github:anaclumos/nix"
# Run this ONLY in a NixOS live installer environment.
# Make sure you have a working network (ping github.com).

DISK="/dev/sda"
EFI_SIZE="512MiB"
FLAKE_URI="github:anaclumos/nix"

echo "===== WARNING ====="
echo "This script will WIPE ALL DATA on $DISK."
read -rp "Are you sure you want to continue? [y/N] " confirm
if [[ "$confirm" != "y" ]]; then
  echo "Aborted."
  exit 1
fi

echo ">>> Partitioning $DISK..."
parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MiB "$EFI_SIZE"
parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart primary "$EFI_SIZE" 100%

echo ">>> Formatting partitions..."
mkfs.fat -F 32 "${DISK}1"
mkfs.ext4 -F "${DISK}2"  # -F to force; be sure you want this!

echo ">>> Mounting partitions..."
mount "${DISK}2" /mnt
mkdir -p /mnt/boot
mount "${DISK}1" /mnt/boot

echo ">>> Installing NixOS from flake: $FLAKE_URI"
nixos-install --flake "$FLAKE_URI"

echo ">>> Done!"
echo "If prompted, set the root password."
echo "Then you can reboot into your new system with:  reboot"
```
