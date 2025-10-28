{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    initContent = ''
      export EDITOR=nvim
    '';
  };
	
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [
      "git"
      "python"
      "man"
    ];
    theme = "agnoster";
  };
}