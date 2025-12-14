# Sunghyun's NixOS


![Framework](https://img.shields.io/badge/Framework-Laptop_13-000000?style=flat&logo=framework&logoColor=white)
![NixOS](https://img.shields.io/badge/NixOS-25.11-5277C3?style=flat&logo=nixos&logoColor=white)
![GNOME](https://img.shields.io/badge/GNOME-Wayland-4A86CF?style=flat&logo=gnome&logoColor=white)
![AMD](https://img.shields.io/badge/AMD-Ryzen_AI_9_HX_370-ED1C24?style=flat&logo=amd&logoColor=white)
![Radeon](https://img.shields.io/badge/Radeon-890M-ED1C24?style=flat&logo=amd&logoColor=white)
![RAM](https://img.shields.io/badge/RAM-96GB-000000?style=flat&logo=crucial&logoColor=white)
![Storage](https://img.shields.io/badge/Storage-4TB_SN850X-000000?style=flat&logo=westerndigital&logoColor=white)

Flake-based NixOS + Home Manager for my Framework Laptop

## Quick Install

```sh
nix-shell -p curl --run 'curl -fsSL https://raw.githubusercontent.com/anaclumos/nix/main/bootstrap.sh | sh'
```

## Hyper Key

Caps Lock becomes a **Hyper key** (Ctrl+Alt+Shift+Super). Tapping it alone triggers `Alt+F10` (maximize window). Holding it enables app-switching chords:

| Chord | Action |
|-------|--------|
| Hyper + J | Focus Chrome (Super+2) |
| Hyper + K | Focus app slot 4 |
| Hyper + L | Focus app slot 5 |
| Hyper + H | Focus app slot 3 |
| Hyper + F | Focus Nautilus (Super+1) |
| Hyper + Enter | Move window to end + top |

## Kana-Style Language Switching

Inspired by Japanese Kana input on macOS:

- **Left Control (tap)** → Switch to English
- **Right Control (tap)** → Switch to Korean (Hangul)

No toggle key. Each hand has a dedicated language. Powered by fcitx5 with `ActivateKeys=Control+Control_R` and `DeactivateKeys=Control+Control_L`.

## Mac-Like Shortcuts

Keyd remaps physical keys to feel like macOS:

| Physical Key | Behavior |
|--------------|----------|
| Left Alt | Command (Ctrl) — copy, paste, cut, tab switching |
| Left/Right Super | Option (Alt) — word navigation, word delete |
| Left/Right Control | Control — browser tab navigation |
| Command + [ / ] | Back / Forward (Alt+Left/Right) |
| Command + Left/Right | Home / End |
| Command + Up/Down | Page Up / Page Down |
| Option + Left/Right | Word jump (Ctrl+Left/Right) |
| Option + Backspace | Delete word (Ctrl+Backspace) |

## Airdrop

```sh
airdrop  # sends all PNGs in ~/Screenshots to iPhone via Taildrop, then deletes them
```

## Other Shortcuts

| Shortcut | Action |
|----------|--------|
| Ctrl + Space | GNOME Overview (Spotlight-like) |
| Ctrl + Shift + Space | 1Password Quick Access |
| Ctrl + L | Lock screen |
| Ctrl + G | Clipboard history |
