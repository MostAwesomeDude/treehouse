{ pkgs, ... }:
{
  # Settings which *every* machine in the lab must have enabled.

  # This causes so many bugs when disabled.
  boot.tmpOnTmpfs = true;

  environment = {
    # Essential packages which we cannot live without.
    systemPackages = with pkgs; [ htop psmisc tmux vim wget ];
    # https://github.com/NixOS/nixpkgs/issues/16545
    wordlist.enable = true;
  };

  # Unbreak pings.
  networking.firewall.allowPing = true;

  # Where we are is when we are.
  time.timeZone = "America/Vancouver";
}
