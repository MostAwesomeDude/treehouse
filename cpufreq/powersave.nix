{ ... }:
{
  # On modern Intel, the intel_pstate driver is used. This driver automatically
  # performs something like ondemand/conservative, but using powersave instead.
  # On older chipsets, we might want conservative instead of powersave. There's
  # no automatic way to determine which to use, though, and getting it wrong
  # means defaulting to performance.
  powerManagement.cpuFreqGovernor = "powersave";
}
