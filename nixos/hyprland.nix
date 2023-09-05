{ config, pkgs, ... }:

{
  # Enabling hyprlnd on NixOS

  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
  };

  services.xserver.displayManager.sddm.enable = true;

  environment.sessionVariables = {
   
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    GBM_BACKEND= "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME= "nvidia";
    LIBVA_DRIVER_NAME= "nvidia"; # hardware acceleration
    __GL_VRR_ALLOWED="1";
    __GL_GSYNC_ALLOWED="1";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    CLUTTER_BACKEND = "wayland";
    # WLR_RENDERER = "vulkan";
   
  };
  
}
