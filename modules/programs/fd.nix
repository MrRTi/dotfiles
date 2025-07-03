{ config, lib, ... }: {
  options = {
    fd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      fd = {
        enable = config.fd.enable;
        hidden = false;
        extraOptions = [];
      };
    };
  };
}
