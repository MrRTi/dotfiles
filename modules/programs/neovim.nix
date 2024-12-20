{ config, lib, ... }: {
  options = {
    neovim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      neovim = {
        # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.enable
        enable = config.neovim.enable;
      };
    };
  };
}
