{ ... }:
{
  services.avahi = {
    enable = true;
    # By default, points to Lennart's personal domain. WTF.
    browseDomains = [];
    # What's the worst that could happen?
    ipv6 = true;
    # Necessary for NSS to work. Without this, we can't look up
    # others on the network.
    nssmdns = true;
    publish = {
      enable = true;
      # IP addresses.
      addresses = true;
      domain = true;
      # Hardware information. OS, CPU, etc.
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };
}
