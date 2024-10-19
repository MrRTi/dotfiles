{ pkgs, config, lib, inputs, username, ... }: {
  options = {
    aerospace = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = false;
      };
    };
  };
  config = lib.mkIf config.aerospace.enable {
    nix-homebrew.taps = {
      "nikitabobko/homebrew-tap" = inputs.homebrew-aerospace;
    };

    homebrew.casks = [
      "nikitabobko/tap/aerospace"
    ];

    home-manager = {
      users.${username} = {
        home.file.aerospaceConfig = {
          target = ".config/aerospace/aerospace.toml";
          text = builtins.readFile ../../sources/config/aerospace/aerospace.toml;
        };
      };
    };
  };
}
