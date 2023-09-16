{ config, pkgs, lib, ... }:

{

  imports = [
    ./shell
    ./programs
  ];
  
  home.username = "lz";
  home.homeDirectory = "/home/lz";
  home.stateVersion = "23.05";
  
  nixpkgs = {
    config = {
    	allowUnfree = true;
    	allowUnfreePredicate = (_: true);
    };
  };
  
  home.packages = (with pkgs; [
   (appimageTools.wrapType2 
     { # or wrapType1
       name = "aliyunpan";
       src = fetchurl {
         url = "https://github.com/gaozhangmin/aliyunpan/releases/download/v3.11.19/XBYDriver-3.11.19-linux-x86_64.AppImage";
         hash = "sha256-LaIqghleQ/k6kZ6DfFYvl3t5oB0tALXg4Z6OFotwhAI=";
       };
       extraPkgs = pkgs: with pkgs; [ ];
     })
  	google-chrome-dev
  	git
  	yesplaymusic
  	aria
  	appimage-run
  	mpv
  	v2ray
  	v2raya
  	polkit
  	telegram-desktop
  	steam-run


  	# hyprland
  	# (pkgs.waybar.overrideAttrs (oldAttrs: {
  	#     mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
  	#   })
  	# )
  	# mako
  	# swww
  	# kitty
  	# rofi-wayland
  	
  ]) ++ (with pkgs.gnome; [ 
    # nautilus
    # zenity
    # gnome-tweaks
    # eog
    gedit
  ]);

  # 设置鼠标指针大小以及字体 DPI（适用于 4K 显示器）
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 100;
  };
  # 
  
  # git 相关配置
  programs.git = {
    enable = true;
    userName = "ivanoflove";
    userEmail = "1666210663@qq.com";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
