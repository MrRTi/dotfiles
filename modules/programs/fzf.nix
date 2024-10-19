{ config, lib, ... }: {
  options = {
    fzf = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      fzf = {
        enable = config.fzf.enable;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;

        tmux.enableShellIntegration = true;
        tmux.shellIntegrationOptions = [ "bottom,40%" ];

        # To follow symbolic links and don't want it to exclude hidden files
        defaultCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
        # Open in tmux popup if on tmux, otherwise use --height mode
        defaultOptions = [
          "--height 40%"
          "--tmux bottom,40%"
          "--layout reverse"
          "--border top"
        ];
      };
    };
  };
}
