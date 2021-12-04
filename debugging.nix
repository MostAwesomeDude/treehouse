{ pkgs, ... }:
{
  # Required for GDB.
  environment.enableDebugInfo = true;
  # Required for breakpointHook.
  environment.systemPackages = [ pkgs.cntr ];
}
