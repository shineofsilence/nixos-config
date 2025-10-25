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

## Установка с минимального образа

1. **Подготовка**
   - Скачайте минимальный образ NixOS с [nixos.org](https://nixos.org/download.html)
   - Создайте загрузочную флешку и загрузитесь с неё
   - В VMware (если используется) добавьте в .vmx файл:
     ```
     firmware = "efi"
     ```
   - Получите root-доступ:
     ```bash
     sudo -s
     ```

2. **Разметка диска**
   ```bash
   fdisk /dev/sda
   # d - Удалить существующие разделы (если есть)
   # g - Создать новую GPT-таблицу (обязательно для UEFI!)
   
   # Создать EFI раздел (512M):
   # n - создать раздел
   #   - размер: `+512M`
   # t - изменить тип: `1` (EFI System)
   
   # Создать корневой раздел (оставшееся место):
   # n - создать раздел
   #   - принять размер по умолчанию (весь оставшийся диск)
   
   # w - записать изменения и выйти
   ```

3. **Создание файловых систем**
   ```bash
   # EFI-раздел (только FAT32!)
   mkfs.fat -F 32 /dev/sda1
   
   # Корневой раздел Btrfs
   mkfs.btrfs -L nixos /dev/sda2
   
   # Монтирование
   mount /dev/sda2 /mnt
   btrfs subvolume create /mnt/@
   umount /mnt
   mount -o subvol=@ /dev/sda2 /mnt
   
   # EFI раздел
   mkdir -p /mnt/boot/efi
   mount /dev/sda1 /mnt/boot/efi
   ```

4. **Настройка swap-файла**
   ```bash
   # Создаем swap-файл (размер в байтах, например, 4G = 4294967296)
   dd if=/dev/zero of=/mnt/swapfile bs=1M count=4096 status=progress
   chmod 600 /mnt/swapfile
   mkswap /mnt/swapfile
   swapon /mnt/swapfile
   ```

5. **Клонирование конфигурации**
   ```bash
   # Установка git
   nix-shell -p git
   
   # Клонирование репозитория
   mkdir -p /mnt/home/kayros
   git clone https://github.com/yourname/nixos-config /mnt/home/kayros/nixos-config
   
   # Генерация конфигурации железа
   nixos-generate-config --root /mnt
   # Или с сохранением в отдельный файл:
   # nixos-generate-config --show-hardware-config > hardware.nix
   
   # Копируем сгенерированные файлы в нашу конфигурацию
   ```

6. **Настройка конфигурации**
   В файле конфигурации NixOS добавьте:
   ```nix
   # Включение swap-файла
   swapDevices = [ 
     { 
       device = "/swapfile";
       size = 4096;  # размер в МБ
     }
   ];
   
   # Или для zram (альтернатива swap-файлу)
   # zramSwap.enable = true;
   # zramSwap.memoryPercent = 50;  # 50% от ОЗУ
   ```

7. **Установка системы**
   ```bash
   # Сборка системы
   nix --extra-experimental-features "nix-command flakes" build .#nixosConfigurations.system.config.system.build.toplevel
   
   # Установка
   nixos-install --root /mnt --system ./result
   
   # После перезагрузки для обновления системы:
   # nixos-rebuild switch --flake ~/nixos-config#system
   ```
   ```
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
