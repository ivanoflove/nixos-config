# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../home-manager/hardware/nvidia.nix
      ../home-manager/environment/fonts.nix
      ../home-manager/environment/fcitx.nix
      ../home-manager/environment/libvirt.nix
      ../home-manager/hardware/mpd.nix
      # ./hyprland.nix
    ];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.efi.efiSysMountPoint = "/efi"; 
  boot.swraid.enable = false;
  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi"; # 默认是 /boot，重点就是改这里

    grub = {
      enable = true;
      device = "nodev";
      default = "1"; # 选择第二个引导项，从0开始计数
      efiSupport = true;

      # 不用 osprober，自己手动添加启动项（通用配置，与实际分区无关）
      extraEntries = ''
        menuentry "Windows" {
         search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
         chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };

  # ''hyprland
  
  # services.xserver.displayManager.gdm.enable = true;

  # xdg.portal = {
    # enable = true;
    # wlr.enable = true;
    # extraPortals = with pkgs; [
      # xdg-desktop-portal-wlr
    # ];
  # };
# 
  # programs.dconf.enable = true;

  # awesome
  # services.xserver = {
    # enable = true;
    # layout = "us";
    # xkbVariant = "";
    # desktopManager = {
        # xfce = {
          # enable = true;
          # noDesktop = true;
          # enableXfwm = false;
        # };
    # };
    # windowManager.awesome.enable = true;
    # libinput.enable = true;
    # libinput.mouse.naturalScrolling = true;
    # libinput.touchpad.naturalScrolling = true;
  # };
  
  # do not need to keep too much generations
  boot.loader.systemd-boot.configurationLimit = 5;
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
    (let base = pkgs.appimageTools.defaultFhsEnvArgs; in
      pkgs.buildFHSUserEnv (base // {
      name = "fhs";
      targetPkgs = pkgs: (
        # pkgs.buildFHSUserEnv 只提供一个最小的 FHS 环境，缺少很多常用软件所必须的基础包
        # 所以直接使用它很可能会报错
        #
        # pkgs.appimageTools 提供了大多数程序常用的基础包，所以我们可以直接用它来补充
        (base.targetPkgs pkgs) ++ (with pkgs; [
          lsb-release
          # pkg-config
          # ncurses
          # 如果你的 FHS 程序还有其他依赖，把它们添加在这里
        ])
      );
      profile = "export FHS=1";
      runScript = "zsh";
      extraOutputsToInstall = ["dev"];
    }))
    lsb-release
    firefox
    # cifs-utils
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

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # environment.sessionVariables.GBM_BACKEND = "nvidia-drm";
  # Optimise storage
  # you can alse optimise the store manually via:
  #    nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;
  
}

