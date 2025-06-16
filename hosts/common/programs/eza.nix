{ config, lib, ... }: {
  options = {
    eza = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      eza = {
        enable = config.eza.enable;
        enableZshIntegration = true;
        git = true;
        extraOptions = [];
      };
    };
  };
}

