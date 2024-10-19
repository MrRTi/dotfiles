{ config, lib, ... }:
{
  options = {
    zsh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      zsh = {
        # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enable
        enable = config.zsh.enable;
      };
    };
  };
}
