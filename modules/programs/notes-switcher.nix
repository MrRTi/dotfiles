{ config, lib, ... }: {
  options = {
    notes-switcher = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = lib.mkIf config.notes-switcher.enable {
    home.file.notes-sessionizer = {
      target = ".local/bin/notes-switcher";
      text = builtins.readFile ./bin/notes-switcher;
      executable = true;
    };
  };
}
