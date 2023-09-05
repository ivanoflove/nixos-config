{ config, lib, pkgs, ... }:


let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
  no-offload = pkgs.writeShellScriptBin "no-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=0
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=
    export __GLX_VENDOR_LIBRARY_NAME=
    export __VK_LAYER_NV_optimus=
    exec "$@"
  '';




in{



  boot.kernelModules = [
    "nvidia"
    "nvidia_drm"
  ];

 

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
  ];
  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfree = pkgs.lib.mkForce true;
  
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true; # steam fix
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
  # environment.sessionVariables = {
    # # If your cursor becomes invisible
    # WLR_NO_HARDWARE_CURSORS = "1";
    # # Hint electron apps to use wayland
    # NIXOS_OZONE_WL = "1";
  # };
  # 
  hardware.nvidia = {
    
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    # Allow headless mode
    # nvidiaPersistenced = true;
    modesetting.enable = true;
    prime = {
      offload.enable = true;
      # allowExternalGpu = true;

      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      amdgpuBusId = "PCI:6:0:0";

      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:1:0:0";

    };

    powerManagement = {
      enable = false;
      # finegrained = true;
    };

  };


  environment.systemPackages = [
    nvidia-offload
    no-offload
  ];
  
  # environment.variables = { MONITOR = "eDP-1"; };
  # environment.sessionVariables = { MONITOR = "eDP-1"; };
  # 
 
  specialisation = {

    
    # external-display.configuration = {
      # system.nixos.tags = [ "external-display" ];
      # hardware.nvidia.prime.offload.enable = lib.mkForce false;
      # hardware.nvidia.powerManagement.enable = lib.mkForce false;
# 
      # environment.variables = { MONITOR = lib.mkForce "DP-1"; };
      # environment.sessionVariables = { MONITOR = lib.mkForce "DP-1"; };
    # };
      # 

    sync.configuration = {
      system.nixos.tags = [ "sync" ];
      boot = {
          kernelParams =
            [ "acpi_rev_override" "mem_sleep_default=deep" "nvidia-drm.modeset=1" ];
          # kernelPackages = pkgs.linuxPackages_5_4;
          # extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
        };
  
      services.xserver = {
        # videoDrivers = [ "nvidia" ];
        config = ''
          Section "Device"
              Identifier  "AMD"
              Driver      "amdgpu"
              #Option      "AccelMethod"  "sna" # default
              #Option      "AccelMethod"  "uxa" # fallback
              Option      "TearFree"        "true"
              Option      "SwapbuffersWait" "true"
              BusID       "PCI:6:0:0"
              #Option      "DRI" "2"             # DRI3 is now default
          EndSection

          Section "Device"
              Identifier "nvidia"
              Driver "nvidia"
              BusID "PCI:1:0:0"
              Option "AllowEmptyInitialConfiguration"
          EndSection
        '';
        screenSection = ''
          Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
          Option         "AllowIndirectGLXProtocol" "off"
          Option         "TripleBuffer" "on"
        '';
      };


      hardware.nvidia.modesetting.enable = true;
      hardware.nvidia.prime.offload.enable = pkgs.lib.mkForce false;
      hardware.nvidia.prime.sync.enable = pkgs.lib.mkForce true;
      hardware.nvidia.powerManagement.enable = pkgs.lib.mkForce false;
      hardware.nvidia.powerManagement.finegrained = pkgs.lib.mkForce false;

      # systemd.services.sink-intel-service = sink-intel-service;
    };
    reverse-prime.configuration = {
      system.nixos.tags = [ "reverse-prime" ];

      hardware.nvidia.modesetting.enable = true;
      hardware.nvidia.prime.offload.enable = pkgs.lib.mkForce false;
      hardware.nvidia.prime.sync.enable = pkgs.lib.mkForce false;
      hardware.nvidia.powerManagement.enable = pkgs.lib.mkForce false;
      hardware.nvidia.powerManagement.finegrained = pkgs.lib.mkForce false;

      hardware.nvidia.prime.reverseSync.enable = true;

      services.xserver = {
        # videoDrivers = [ "nvidia" ];

        config = ''
           Section "Device"
               Identifier  "AMD"
               Driver      "amdgpu"
               #Option      "AccelMethod"  "sna" # default
               #Option      "AccelMethod"  "uxa" # fallback
               Option      "TearFree"        "true"
               Option      "SwapbuffersWait" "true"
               BusID       "PCI:6:0:0"
               #Option      "DRI" "2"             # DRI3 is now default
           EndSection

          # Section "Device"
          #     Identifier "nvidia"
          #     Driver "nvidia"
          #     BusID "PCI:1:0:0"
          #     Option "AllowEmptyInitialConfiguration"
          # EndSection
        '';
        screenSection = ''
          Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
          Option         "AllowIndirectGLXProtocol" "off"
          Option         "TripleBuffer" "on"
        '';
      };

      # systemd.services.sink-intel-service = sink-intel-service;
    };
  };

}
