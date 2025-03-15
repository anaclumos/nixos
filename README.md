# nix

```bash
#!/usr/bin/env bash

# Script: install-nixos.sh
# Wipes /dev/sda and installs NixOS from the flake github:anaclumos/nix#myHostname
# Make sure you're running as root (sudo su -) on the NixOS live installer.

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "ERROR: This script must be run as root. Try: sudo ./install-nixos.sh"
  exit 1
fi

DISK="/dev/sda"
EFI_SIZE="512MiB"

# This is your flake URI. The part after '#' is the name of the config in flake.nix
FLAKE_URI="github:anaclumos/nix"
FLAKE_CONFIG="myHostname"  # <-- Adjust to match the nixosConfigurations attribute in your flake.nix

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
mkfs.ext4 -F "${DISK}2"

echo ">>> Mounting partitions..."
mount "${DISK}2" /mnt
mkdir -p /mnt/boot
mount "${DISK}1" /mnt/boot

echo ">>> Installing NixOS from flake: $FLAKE_URI#$FLAKE_CONFIG"
nixos-install --flake "$FLAKE_URI#$FLAKE_CONFIG"

echo ">>> Done!"
echo "If prompted, set the root password."
echo "Remove the installer USB, then reboot into your new system with:  reboot"
```
