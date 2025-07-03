{ config, lib, ... }: {
  options = {
    bat = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      bat = {
        enable = config.bat.enable;
        config = {
          theme = "ansi";
        };
      };

      fish = lib.mkIf (config.bat.enable && config.fish.enable) {
        shellAliases = {
          cat = "bat -pp";
          less = "bat -p";
          lessl = "bat -pl";
        };
      };
    };
  };
}

