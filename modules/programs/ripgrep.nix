{ config, lib, ... }: {
  options = {
    ripgrep = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      ripgrep = {
        enable = config.ripgrep.enable;
      };
    };
  };
}
