{ config, lib, pkgs, ... }: {
  options = {
    kanata = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    home = lib.mkIf config.kanata.enable {
      packages = with pkgs; [kanata];
      file.macbook-iso-keyboard = {
        target = ".config/kanata/macbook-iso-keyboard.kbd";
        text = builtins.readFile ../../home/kanata/macbook-iso-keyboard.kbd;
        executable = false;
      };
    };
  };
}
