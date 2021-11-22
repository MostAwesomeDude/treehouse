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
    alertmanagers = [{
      static_configs = [{
        targets = [ "batmite.local:9093" ];
      }];
    }];
    scrapeConfigs = [
      {
        job_name = "mdns-sd";
        file_sd_configs = [
          {
            files = [ exportJSON ];
          }
        ];
      }
      {
        job_name = "alertmanager";
        static_configs = [{
          targets = [ "batmite.local:9093" ];
        }];
      }
    ];
    rules = [''
      groups:
        - name: tlc
          rules:
          - alert: OverheatingMachine
            expr: avg(node_hwmon_temp_celsius) by (instance) >= 70.0
            for: 5m
            labels:
              severity: page
            annotations:
              summary: Machine {{ $labels.instance }} is overheating
          - alert: LowNixStoreSpace
            expr: node_filesystem_avail_bytes{mountpoint="/nix/store"} < (1024 * 1024 * 1024)
            for: 5m
            labels:
              severity: page
            annotations:
              summary: Machine {{ $labels.instance }} has < 1GiB Nix store space
    ''];
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
