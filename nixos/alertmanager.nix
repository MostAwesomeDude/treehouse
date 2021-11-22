{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.blink1-tool ];
  networking.firewall.allowedTCPPorts = [ 9093 ];
  services.prometheus.alertmanager = {
    enable = true;
    configuration = {
      route = {
        receiver = "default-receiver";
      };
      receivers = [{
        name = "default-receiver";
      }];
    };
  };
  systemd = {
    timers.check-alerts = {
      wantedBy = [ "timers.target" ];
      partOf = [ "check-alerts.service" ];
      timerConfig.OnCalendar = "minutely";
    };
    services.check-alerts = {
      serviceConfig.Type = "oneshot";
      script = ''
        if $(${pkgs.curl}/bin/curl http://localhost:9093/metrics |
             ${pkgs.gawk}/bin/awk '/^alertmanager_alerts{state="active"}/ { exit $2 }')
        then if $(${pkgs.curl}/bin/curl http://localhost:9093/metrics |
                  ${pkgs.gawk}/bin/awk '/^alertmanager_alerts{state="suppressed"}/ { exit $2 }')
             then ${pkgs.blink1-tool}/bin/blink1-tool --green
             else ${pkgs.blink1-tool}/bin/blink1-tool --cyan
             fi
        else
          ${pkgs.blink1-tool}/bin/blink1-tool --magenta --glimmer=20
          ${pkgs.blink1-tool}/bin/blink1-tool --red
        fi
      '';
    };
  };
}
