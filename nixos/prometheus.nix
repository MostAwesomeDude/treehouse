{ pkgs, ... }:
let
  # prometheus-mdns-sd = pkgs.callPackage ../prometheus-mdns-sd {};
  exportJSON = "/var/lib/prometheus-mdns-sd.json";
  prometheus-mdns-sd = pkgs.writeShellScript "prom-mdns-sd.sh" ''
    set -exu -o pipefail
    ${pkgs.avahi}/bin/avahi-browse -r -t -p _prometheus-http._tcp \
      | grep '^=' \
      | ${pkgs.jq}/bin/jq -s -R '. / "\n"
        | map(select(length > 0)
          | . / ";"
          | { targets: [ "\(.[7]):\(.[8])" ],
              labels: { __scheme__: "http",
                        __meta_: "",
                        instance: .[6] }})' \
      > ${exportJSON}.$$
    mv ${exportJSON}{.$$,}
  '';
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

  systemd = {
    timers.prometheus-mdns-sd = {
      description = "Prometheus mDNS service discovery";
      wantedBy = [ "multi-user.target" ];

      timerConfig = {
        OnCalendar = "minutely";
        Unit = "prometheus-mdns-sd.service";
      };
    };

    services.prometheus-mdns-sd = {
      wantedBy = [ "prometheus.service" ];

      path = [ prometheus-mdns-sd ];

      serviceConfig = {
        # ExecStart = "${prometheus-mdns-sd}/bin/prometheus-mdns-sd -out ${exportJSON}";
        ExecStart = prometheus-mdns-sd;
        Type = "oneshot";
      };
    };
  };
}
