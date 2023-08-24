{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "dst";
    };
    initExtra = ''
      bindkey '^f' autosuggest-accept
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
