{ config, pkgs, ... }:

{
  home = {
    sessionVariables = {
    EDITOR = "lvim";
    BROWSER = "librewolf";
    TERMINAL = "kitty";
    
    GBM_BACKEND= "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME= "nvidia";
    LIBVA_DRIVER_NAME= "nvidia"; # hardware acceleration
    __GL_VRR_ALLOWED="1";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    CLUTTER_BACKEND = "wayland";
    WLR_RENDERER = "vulkan";

    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";

    # 解决QT程序缩放问题
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    # QT使用wayland和gtk
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    # 使用qt5ct软件配置QT程序外观
    QT_QPA_PLATFORMTHEME = "qt5ct"; 
	  
    # 一些游戏使用wayland
    SDL_VIDEODRIVER = "wayland";
    # 解决java程序启动黑屏错误
    _JAVA_AWT_WM_NONEREPARENTING = "1"; 
    # GTK后端为 wayland和x11,优先wayland 
    GDK_BACKEND = "wayland,x11";

    GTK_IM_MODULE = "fcitx5";
    QT_IM_MODULE = "fcitx5";
    SDL_IM_MODULE = "fcitx5";
    XMODIFIERS= "@im=fcitx5";

	
      
    };
  };
}
