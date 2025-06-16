{ config, lib, ... }: {
  options = {
    bottom = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      bottom.enable = config.bottom.enable;
    };
  };
}

