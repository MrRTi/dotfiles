{ config, lib, ... }: {
  options = {
    tealdeer = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      tealdeer = {
        enable = config.tealdeer.enable;
        settings.updates.auto_update = true;
      };

      fish = lib.mkIf (config.tealdeer.enable && config.fish.enable) {
        shellAliases = {
          tldrf="tldr --list | fzf --preview \"tldr {1} --color=always\" --preview-window=right,70% | xargs tldr";
        };
      };
    };
  };
}
