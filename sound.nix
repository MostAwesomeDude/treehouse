{ config, pkgs, ... }:
{
  # Enable sound.
  sound.enable = true;
  hardware = {
    # Enable BT radios. BT audio is enabled by BT + PA.
    bluetooth.enable = true;
    pulseaudio = {
      enable = true;
      # If X11 is enabled, then we will need x11publish.
      package = if config.services.xserver.enable then pkgs.pulseaudioFull else pkgs.pulseaudio;
    };
  };
}
