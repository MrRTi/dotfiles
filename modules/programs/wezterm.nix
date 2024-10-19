{ config, lib, ... }: {
  options = {
    wezterm = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      wezterm = {
        enable = config.wezterm.enable;
        enableBashIntegration = true;
        enableZshIntegration = true;
        extraConfig = builtins.readFile ../../sources/config/wezterm/wezterm.lua;
      };
    };
  };
}
