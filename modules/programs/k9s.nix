{ config, lib, ... }: {
  options = {
    k9s = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      k9s = {
        enable = config.k9s.enable;
        settings = {
          k9s = {
            refreshRate = 2;
            ui = {
              skin = "transparent";
            };
          };
        };
        skins = {
          transparent = ../../home/k9s/skins/transparent.yaml; 
        };
        views = {
          views = {
            "v1/pods" = {
              columns = [
                "AGE"
                "NAMESPACE"
                "NAME"
                "IP"
                "NODE"
                "STATUS"
                "READY"
              ];
            };
            "v1/services" = {
              columns = [
                "AGE"
                "NAMESPACE"
                "NAME"
                "TYPE"
                "CLUSTER-IP"
              ];
            };
            "v1/containers" = {
              columns = [
                "AGE"
                "NAME"
                "IMAGE"
                "PF"
                "READY"
                "RESTARTS"
                "PORTS"
              ];
            };
          };
        };
      };
    };
  };
}
