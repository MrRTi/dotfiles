{ config, lib, ... }: {
  options = {
    home-manager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      home-manager = {
        enable = config.home-manager.enable;
      };
    };
  };
}
