{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "nix"
        "python"
        "docker"
        "haskell"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
      ];
    };

    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
    };

    initExtra = ''
      # Настройки истории
      HISTSIZE=10000
      SAVEHIST=10000
      HISTFILE=~/.zsh_history
      
      # Включение автодополнения
      autoload -U compinit && compinit
      
      # Установка курсора в конец строки при навигации по истории
      autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      
      # Настройка клавиш для навигации по истории
      bindkey '^[[A' up-line-or-beginning-search
      bindkey '^[OA' up-line-or-beginning-search
      bindkey '^[[B' down-line-or-beginning-search
      bindkey '^[OB' down-line-or-beginning-search
    '';
  };
}