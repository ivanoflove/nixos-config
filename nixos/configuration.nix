# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidiasy.nix
      ./fonts.nix
      ./fcitx.nix
      ./libvirt.nix

      # ./hyprland.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi"; 

  # do not need to keep too much generations
  boot.loader.systemd-boot.configurationLimit = 5;
  
  # gpu set
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.supportedFilesystems = [ "ntfs" ];
  
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true; 
  
  # Easiest to use and most distros use this by default.
  services.blueman.enable = true;
  services.gnome.gnome-keyring.enable = true;
  hardware = {
  #    pulseaudio.enable = true;
    bluetooth.enable = true;
  };
  
  # programs.clash-verge = {
    # enable = true;
    # autoStart = true;
    # tunMode = true;
  # };
  # 
  # environment.sessionVariables = rec {
    # # fix nvidia
    # LIBVA_DRIVER_NAME = "nvidia";
    # XDG_SESSION_TYPE = "wayland";
    # # GBM_BACKEND = "nvidia-drm";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # WLR_NO_HARDWARE_CURSORS = "1";
    # QT_QPA_PLATFORM= "wayland;xcb";
    # # __EGL_VENDOR_LIBRARY_FILENAMES = "/usr/share/glvnd/egl_vendor.d/50_mesa.json";
  # };
  # samba
  # networking.firewall.enable = true;
  # networking.firewall.allowPing = true;
  # services.samba.openFirewall = true;
  # 
  # services.samba = {
    # enable = true;
    # securityType = "user";
    # extraConfig = ''
      # workgroup = WORKGROUP
      # server string = smbnix
      # netbios name = smbnix
      # security = user
      # #use sendfile = yes
      # #max protocol = smb2
      # # note: localhost is the ipv6 localhost ::1
      # hosts allow = 192.168.0. 127.0.0.1 localhost
      # hosts deny = 0.0.0.0/0
      # guest account = nobody
      # map to guest = bad user
    # '';
    # shares = {
      # Media = {
        # path = "/media";
        # browseable = "yes";
        # "read only" = "no";
        # "guest ok" = "no";
        # "create mask" = "0777";
        # "directory mask" = "0777";
        # "force user" = "lz";
    # 
     # 
    # };
      # 
    # };
  # };
  
  services.v2raya.enable = true;
  
  services.supergfxd.enable = false;
  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
  
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.power-profiles-daemon.enable = true;

 
  
  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Enable KDE
 
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    gwenview
    okular
    oxygen
    khelpcenter
    # konsole
    plasma-browser-integration
    print-manager
  ];
 # 
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  # 
  # sound.enable = true;
  hardware.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.cudaSupport = true;
  security.sudo.wheelNeedsPassword = false;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "lz" ];
  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lz = {
    isNormalUser = true;
    description = "lz";
    extraGroups = [ "wheel" "networkmanager" "video" "kvm" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  environment.shells = with pkgs; [ zsh ];
  
  environment.systemPackages = with pkgs;[
    power-profiles-daemon
    blueman
    gnome.gnome-keyring
    cifs-utils
    # python
    # (python311.withPackages(ps: with ps; [ pandas numpy ]))
    # gcc
  ];


  # ];
  # do garbage collection weekly to keep disk usage low
  system.stateVersion = "23.05"; # Did you read the comment?
  
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

 
  # Optimise storage
  # you can alse optimise the store manually via:
  #    nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;
  
}

