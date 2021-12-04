{ pkgs, ... }:
{
  # Settings which *every* machine in the lab must have enabled.

  # Essential packages which we cannot live without.
  environment.systemPackages = with pkgs; [ htop tmux vim ];

  # Unbreak pings.
  networking.firewall.allowPing = true;

  # Where we are is when we are.
  time.timeZone = "America/Vancouver";
}
