{ pkgs, config, ... }:
{
  services = {
    # Node exporter.
    prometheus.exporters.node = {
      enable = true;
      openFirewall = true;
      enabledCollectors = [ "systemd" "textfile" "wifi" ];
      extraFlags = [
        "--collector.textfile.directory=/var/lib/prom/"
      ];
    };

    # mDNS for node exporter.
    avahi.extraServiceFiles.prom = ''
      <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
      <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
      <service-group>
        <name replace-wildcards="yes">Prometheus Exporter for %h</name>
        <service protocol="ipv4">
          <type>_prometheus-http._tcp</type>
          <port>9100</port>
        </service>
      </service-group>
    '';
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
