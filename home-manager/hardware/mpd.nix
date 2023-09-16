{config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # ncmpcpp
    cantata
  ];
  services.mpd = {
    enable = true;
    musicDirectory = "/home/lz/Music";
    user = "lz";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "My PipeWire Output"
      }
      # must specify one or more outputs in order to play audio!
      # (e.g. ALSA, PulseAudio, PipeWire), see next sections
    '';
  
    # Optional:
    network.listenAddress = "any"; # if you want to allow non-localhost connections
    startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
  };
  
  # services.mpd.user = "userRunningPipeWire";
  systemd.services.mpd.environment = {
      # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
      XDG_RUNTIME_DIR = "/run/user/1000"; # User-id 1000 must match above user. MPD will look inside this directory for the PipeWire socket.
  };
}
