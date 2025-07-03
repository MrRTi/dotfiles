{ config, lib, ... }: {
  options = {
    lazygit = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      lazygit = {
        enable = config.lazygit.enable;
      };
    };
  };
}
