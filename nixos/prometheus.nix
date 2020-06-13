{ pkgs, ... }:
let
  prometheus-mdns-sd = pkgs.callPackage ../prometheus-mdns-sd {};
in
{
  # Prometheus server/scraper.
  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      {
        job_name = "mdns-sd";
        file_sd_configs = [
          {
            files = [ "/var/lib/prometheus-mdns-sd.json" ];
          }
        ];
      }
    ];
  };

  systemd.services.prometheus-mdns-sd = {
    description = "Prometheus mDNS service discovery";
    wantedBy = [ "multi-user.target" ];

    path = [ prometheus-mdns-sd ];

    serviceConfig = {
      ExecStart = "${prometheus-mdns-sd}/bin/prometheus-mdns-sd -out /var/lib/prometheus-mdns-sd.json";
    };
  };
}
