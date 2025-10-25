{ pkgs, ... }: {
  # Устанавливаем git как пользовательский пакет
  home.packages = [ pkgs.git ];

  # Настраиваем git
  programs.git = {
    enable = true;
    userName = "KayRos";
    userEmail = "shineofsilence@github.com";
    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = true;
    };
  };
}