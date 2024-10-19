{ config, lib, ... }: {
  options = {
    direnv = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      direnv = {
        enable = config.direnv.enable;
        enableBashIntegration = true;

        # NOTE: enabling the direnv module
        # will always active its functionality for Fish since the direnv package automatically gets loaded in Fish
        # if set to true here - raising "it's set multiple times"
        # enableFishIntegration = true;

        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}

