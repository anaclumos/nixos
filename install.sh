#!/usr/bin/env bash
#
# install-nixos.sh: Wipe /dev/sda, partition, format, and install NixOS
# via flake "github:anaclumos/nix#sunghyuncho".
#
# Usage:
#   curl -L https://raw.githubusercontent.com/anaclumos/nix/main/install.sh | sudo bash
#
# MAKE SURE /dev/sda IS NOT YOUR LIVE USB. This script is DESTRUCTIVE.

set -euo pipefail

DISK="/dev/sda"
EFI_SIZE="512MiB"
FLAKE_URI="github:anaclumos/nix"
FLAKE_CONFIG="sunghyuncho"

########################################
# 1. Must run as root
########################################
if [[ $EUID -ne 0 ]]; then
  echo "ERROR: This script must be run as root. Try: sudo bash"
  exit 1
fi

########################################
# 2. Basic checks: parted, nixos-install, etc.
########################################
for cmd in parted partprobe mkfs.fat mkfs.ext4 nixos-install nixos-generate-config ping; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: '$cmd' not found. Are you on the NixOS Live Installer?"
    exit 1
  fi
done

########################################
# 3. Check if /dev/sda is currently mounted as root
########################################
# This is a heuristic check. If /dev/sda or any partition of it is mounted at /, abort.
if mount | grep -qE '^/dev/sda.*/ '; then
  echo "ERROR: It looks like /dev/sda is in use (mounted as root)."
  echo "You cannot wipe the disk you're booted from!"
  exit 1
fi

########################################
# 4. Final warning
########################################
cat <<EOF
============================================================
   WARNING: This will completely WIPE ALL DATA on $DISK!
   It will create a GPT label, EFI partition, ext4 partition,
   then install NixOS from flake: $FLAKE_URI#$FLAKE_CONFIG
============================================================
EOF

# >>> The line changed here to force reading from /dev/tty:
read -rp "Are you sure you want to continue? [y/N] " confirm </dev/tty
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Aborted."
  exit 1
fi

########################################
# 5. Partition /dev/sda (UEFI)
########################################
echo ">>> Partitioning $DISK..."
parted -s "$DISK" mklabel gpt
parted -s "$DISK" mkpart ESP fat32 1MiB "$EFI_SIZE"
parted -s "$DISK" set 1 esp on
parted -s "$DISK" mkpart primary "$EFI_SIZE" 100%

# Force the kernel to re-read partition table
partprobe "$DISK" || true

# Show partitions for verification
echo ">>> Partition table on $DISK now:"
parted "$DISK" print || true

########################################
# 6. Format Partitions
########################################
echo ">>> Formatting partitions..."
mkfs.fat -F 32 "${DISK}1"
mkfs.ext4 -F "${DISK}2"

########################################
# 7. Mount Partitions
########################################
echo ">>> Mounting root partition at /mnt"
mount "${DISK}2" /mnt
mkdir -p /mnt/boot
echo ">>> Mounting EFI partition at /mnt/boot"
mount "${DISK}1" /mnt/boot

########################################
# 8. Generate hardware configuration
########################################
echo ">>> Generating hardware-configuration.nix..."
nixos-generate-config --root /mnt
echo ">>> Hardware configuration generated at /mnt/etc/nixos/hardware-configuration.nix"

########################################
# 9. Copy hardware-configuration.nix to flake location
########################################
echo ">>> Setting up hardware configuration for the flake..."

# Create a temporary directory to clone the flake repository
TEMP_DIR=$(mktemp -d)
echo ">>> Cloning flake repository to $TEMP_DIR..."
if ! nix flake clone "$FLAKE_URI" --dest "$TEMP_DIR"; then
  echo "ERROR: Failed to clone the flake repository."
  exit 1
fi

# Copy the generated hardware-configuration.nix to the flake directory
echo ">>> Copying hardware-configuration.nix to flake directory..."
cp /mnt/etc/nixos/hardware-configuration.nix "$TEMP_DIR/"

# Quick network check
echo ">>> Checking network connectivity..."
if ! ping -c 1 github.com >/dev/null 2>&1; then
  echo "ERROR: No network connectivity to GitHub. Fix your internet before installing."
  exit 1
fi

########################################
# 10. Check if lock file exists and install NixOS
########################################
echo ">>> Installing NixOS from flake: $FLAKE_URI#$FLAKE_CONFIG"

# Check if we need to use --no-write-lock-file
if [[ -e "/mnt/nix/store" ]]; then
  echo ">>> Detected existing Nix store, using --no-write-lock-file to avoid lock conflicts"
  nixos-install --flake "$FLAKE_URI#$FLAKE_CONFIG" --no-write-lock-file
else
  nixos-install --flake "$FLAKE_URI#$FLAKE_CONFIG"
fi

echo
echo ">>> Installation is complete!"
echo "If prompted, set the root password."
echo "Afterward, REMOVE the installer USB and reboot into your new NixOS system:"
echo "    reboot"
