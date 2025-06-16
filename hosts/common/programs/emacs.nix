{ config, lib, ... }: {
  options = {
    emacs = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.emacs.enable
      emacs = {
        enable = config.emacs.enable;
      };

      fish = lib.mkIf (config.emacs.enable && config.fish.enable) {
        shellAbbrs = {
          em = "emacs --tty";
          emd = "emacs --daemon";
          emc = "emacsclient -c -a \"\" --tty";
        };
      };
    };
  };
}
