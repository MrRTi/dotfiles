{ config, lib, ... }: {
  options = {
    tmux-sessionizer = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = lib.mkIf config.tmux-sessionizer.enable {
    home.file.tmux-sessionizer = {
      target = ".local/bin/tmux-sessionizer";
      text = builtins.readFile ../../home/bin/tmux-sessionizer;
      executable = true;
    };
  };
}
