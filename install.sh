#!/bin/bash
# nixos-install-script.sh - Run this directly on the NixOS live environment
set -e

# Set variables
REPO_URL="https://github.com/anaclumos/nix.git"
HOSTNAME="sunghyuncho"
USE_FLAKE=true

# Ensure target directory exists
echo "Creating target directory..."
sudo mkdir -p /mnt/etc/nixos

# Clone the repository
echo "Cloning configuration from $REPO_URL..."
sudo git clone $REPO_URL /mnt/etc/nixos

# Generate hardware configuration
echo "Generating hardware configuration..."
sudo nixos-generate-config --root /mnt

# Install NixOS
echo "Installing NixOS..."
if [ "$USE_FLAKE" = true ]; then
  echo "Using flake-based installation..."
  sudo nixos-install --flake /mnt/etc/nixos#$HOSTNAME
else
  echo "Using standard installation..."
  sudo nixos-install
fi

echo "NixOS installation completed successfully!"
