{ config, pkgs, ... }: {
  # Убедимся, что git установлен
  environment.systemPackages = [ pkgs.git ];

  # Создаём ~/.gitconfig при применении конфигурации
  system.activationScripts.gitconfig = ''
    mkdir -p /home/kayros
    cat > /home/kayros/.gitconfig <<EOF
[user]
  name = KayRos
  email = shineofsilence@github.com
[init]
  defaultBranch = main
EOF
    chown -R kayros:kayros /home/kayros/.gitconfig
  '';
}