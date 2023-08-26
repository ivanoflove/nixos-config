{ config, lib, pkgs, ... }:

{
  services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  services.switcherooControl.enable = true;

  programs.xwayland.enable = true;
  # services.xserver.displayManager.gdm.wayland = true;

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = lib.mkForce false;
    # when use offload
    # powerManagement = {
        # enable = pkgs.lib.mkForce false;
        # finegrained = pkgs.lib.mkForce false;
        # enable = true;
        # finegrained = true;
      # };

    prime = {

      offload.enable = lib.mkForce false;
      sync.enable = true;

      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:6:0:0";
    };
  };
}
