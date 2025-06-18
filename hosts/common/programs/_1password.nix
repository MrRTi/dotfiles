{ config, lib, pkgs, ... }: {
  options = {
    _1password = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = lib.mkIf config._1password.enable {
    home = {
      file = {
        _1password-config = {
          target = ".config/1Password/ssh/agent.toml";
          text = builtins.readFile ./_1password/agent.toml;
        };
      };
      packages = with pkgs; [
        _1password-cli
        _1password-gui
      ];
    };
  };
}

