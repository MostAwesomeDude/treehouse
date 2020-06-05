{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.vulnix ];
}
