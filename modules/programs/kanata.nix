{ config, lib, pkgs, ... }: {
  options = {
    kanata = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
      daemon = lib.mkOption {
        type = lib.types.bool;
        description = "Enable daemon";
        default = false;
      };
      layer-monitor = lib.mkOption {
        type = lib.types.bool;
        description = "Enable layer monitor in menu bar";
        default = false;
      };
      port = lib.mkOption {
        type = lib.types.port;
        description = "Port";
        default = 4444;
      };
    };
  };

  config = {
    home = lib.mkIf config.kanata.enable {
      packages = with pkgs; [kanata];
      file.macbook-iso-keyboard = {
        target = "/etc/kanata/macbook-iso-keyboard.kbd";
        text = builtins.readFile ./kanata/macbook-iso-keyboard.kbd;
        executable = false;
      };
    };
    # launchd.daemons = lib.mkIf config.kanata.daemon {
    #   kanata = {
    #     enable = config.kanata.daemon;
    #     config = {
    #       ProgramArguments = [
    #         "kanata"
    #         "-c"
    #         "/etc/kanata/macbook-iso-keyboard.kbd"
    #         "-p"
    #         config.kanata.port
    #       ];
    #       RunAtLoad = true;
    #       StandardOutPath = "/var/log/kanata.out";
    #       StandardErrorPath = "/var/log/kanata.err";
    #     };
    #   };
    # };
  };
}
