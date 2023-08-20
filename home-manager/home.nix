{ config, pkgs, ... }:

{

  imports = [
    ./shell/zsh.nix
    ./shell/micro.nix
    ./shell/alacritty.nix
  ];
  
  home.username = "lz";
  home.homeDirectory = "/home/lz";
  home.stateVersion = "23.05";
  home.packages = with pkgs;[
  	v2ray
  	v2raya
  	google-chrome-dev
  	git
  	vscode
  	yesplaymusic
  	aria
  	appimage-run
  	mpv
  ];

  # 设置鼠标指针大小以及字体 DPI（适用于 4K 显示器）
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };
  
 
  # git 相关配置
  programs.git = {
    enable = true;
    userName = "ivanoflove";
    userEmail = "1666210663@qq.com";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
