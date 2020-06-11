{ pkgs, config, ... }:
{
  services = {
    prometheus.exporters.node = {
      enable = true;
      openFirewall = true;
      enabledCollectors = [ "systemd" "textfile" "wifi" ];
      extraFlags = [
        "--collector.textfile.directory=/var/lib/prom/"
      ];
    };
  };

  # system_version{release="20.XX",state="19.XX"} generation
  system.activationScripts.prom = ''
    mkdir -p -m 0755 /var/lib/prom/
    printf 'system_version_generation{release="%s",state="%s"} %d\n' \
      ${config.system.nixos.release} \
      ${config.system.stateVersion} \
      $(readlink /nix/var/nix/profiles/system | cut -d- -f2) \
      > /var/lib/prom/version.prom.$$
    printf 'system_version_build_timestamp{release="%s",state="%s"} %d\n' \
      ${config.system.nixos.release} \
      ${config.system.stateVersion} \
      $(stat -c %W $(readlink -f /nix/var/nix/profiles/system)) \
      >> /var/lib/prom/version.prom.$$
    mv /var/lib/prom/version.prom{.$$,}
  '';
}
