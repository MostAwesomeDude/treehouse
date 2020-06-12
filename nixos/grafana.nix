{ ... }:
let
  promURL = http://harley.local:9090/;
in
{
  services.grafana = {
    enable = true;
    auth.anonymous = {
      enable = true;
      org_role = "Editor";
    };
    provision = {
      enable = true;
      datasources = [
        {
          name = "prom";
          type = "prometheus";
          url = promURL;
        }
      ];
      dashboards = [
        {
          folder = "Misc";
          options.path = ../grafana/dashboards;
        }
      ];
    };
  };
}
