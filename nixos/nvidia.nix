{ config, lib, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  services.switcherooControl.enable = true;

  programs.xwayland.enable = true;
  # services.xserver.displayManager.gdm.wayland = true;

  # 同步
  specialisation = {
    external-display.configuration = {
      system.nixos.tags = [ "external-display" ];
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce false;
        powerManagement.enable = lib.mkForce false;
      };
    };
  };
  
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    nvidiaSettings = true;
    # when use offload
    # powerManagement = {
        # enable = pkgs.lib.mkForce false;
        # finegrained = pkgs.lib.mkForce false;
        # enable = true;
        # finegrained = true;
      # };

    prime = {

      # 同步
  	  # offload.enable = pkgs.lib.mkForce false;
  	  # sync.enable = pkgs.lib.mkForce true;
  	  
      # offload = {
      # enable = true;
      # enableOffloadCmd = true;
      # };
      sync.enable = true;

      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:6:0:0";
    };
  };
}
