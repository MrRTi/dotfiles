{ config, lib, ... }: {
  options = {
    tmux = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      tmux = {
        # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.tmux.enable
        enable = config.tmux.enable;
        extraConfig = builtins.readFile ../../home/tmux/tmux.conf;
      };
    };
  };
}
