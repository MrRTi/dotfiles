{ config, lib, ... }: {
  options = {
    jq = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      jq.enable = config.jq.enable;
    };
  };
}
