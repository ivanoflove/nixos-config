{ config, lib, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  environment.systemPackages = [ nvidia-offload ];
  
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  services.switcherooControl.enable = true;

  programs.xwayland.enable = true;
  # services.xserver.displayManager.gdm.wayland = true;

  
  # 
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
    # when use offload
    # powerManagement = {
        # enable = true;
        # finegrained = true;
      # };

    prime = {
    	
        offload = {
        enable = true;
        # enableOffloadCmd = true;
        };
        # sync.enable = true;

        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:6:0:0";
    };
  };
}
