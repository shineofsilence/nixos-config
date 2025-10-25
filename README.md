# Minimal Hyprland NixOS Configuration

This is a minimal, yet functional Hyprland configuration for NixOS, designed to be lightweight and easy to customize.

## Features

- **Window Manager**: Hyprland with basic keybindings
- **Terminal**: Alacritty with a clean configuration
- **File Manager**: Thunar
- **App Launcher**: Wofi
- **Status Bar**: Waybar
- **Network Management**: NetworkManager with applet
- **Audio**: PipeWire with PulseAudio compatibility
- **Theming**: Basic GTK and icon themes

## Installation

1. **Boot into NixOS Minimal ISO**
   - Download the latest NixOS minimal ISO from [nixos.org](https://nixos.org/download.html)
   - Create a bootable USB and boot from it

2. **Partitioning** (adjust as needed)
   ```bash
   # For UEFI systems
   parted /dev/sda -- mklabel gpt
   parted /dev/sda -- mkpart primary 512MiB -8GiB
   parted /dev/sda -- mkpart primary linux-swap -8GiB 100%
   parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
   parted /dev/sda -- set 3 esp on
   
   # Format partitions
   mkfs.ext4 -L nixos /dev/sda1
   mkswap -L swap /dev/sda2
   mkfs.fat -F 32 -n boot /dev/sda3
   
   # Mount partitions
   mount /dev/disk/by-label/nixos /mnt
   mkdir -p /mnt/boot
   mount /dev/disk/by-label/boot /mnt/boot
   swapon /dev/sda2
   ```

3. **Generate hardware configuration**
   ```bash
   nixos-generate-config --root /mnt
   ```

4. **Clone this repository**
   ```bash
   nix-shell -p git
   git clone https://github.com/yourusername/nixos-hyprland-config /mnt/etc/nixos
   cd /mnt/etc/nixos
   ```

5. **Copy hardware configuration**
   ```bash
   cp /mnt/etc/nixos/hardware-configuration.nix .
   ```

6. **Edit configuration**
   - Update `configuration.nix` with your username and hostname
   - Update `home-manager/home.nix` with your personal information

7. **Install NixOS**
   ```bash
   nixos-install --flake .#nixos
   ```

8. **Set root password and reboot**
   ```bash
   passwd
   reboot
   ```

## Post-Installation

1. **Login** with your username and password
2. **Start Hyprland** by selecting it from your display manager

## Keybindings

- `Super + Return`: Open terminal
- `Super + D`: Open application launcher
- `Super + Q`: Close window
- `Super + F`: Toggle fullscreen
- `Super + P`: Take a screenshot of selected area
- `Super + V`: Toggle floating window
- `Super + Arrow Keys`: Move focus between windows

## Customization

- **Wallpaper**: Place your wallpaper at `~/.config/hypr/wallpaper.jpg`
- **GTK Theme**: Edit `home-manager/home.nix` to change the theme
- **Hyprland Config**: Modify `home-manager/home.nix` for Hyprland settings

## Troubleshooting

- If you have issues with graphics, check the logs:
  ```bash
  journalctl -u display-manager -b
  ```
- For Wayland issues, check:
  ```bash
  journalctl -u hyprland -b
  ```

## Updating

```bash
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#nixos
```

## License

MIT
