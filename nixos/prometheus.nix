{ pkgs, ... }:
let
  prometheus-mdns-sd = pkgs.callPackage ../prometheus-mdns-sd {};
  exportJSON = "/var/lib/prometheus-mdns-sd.json";
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
            files = [ exportJSON ];
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
      ExecStart = "${prometheus-mdns-sd}/bin/prometheus-mdns-sd -out ${exportJSON}";
    };
  };
}
