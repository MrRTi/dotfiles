{ pkgs, config, lib, inputs, username, ... }: {
  options = {
    safari-qol= {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = false;
      };
    };
  };
  config = lib.mkIf config.safari-qol.enable {
    homebrew.brews = [
      "mas"
    ];

    homebrew.masApps = {
      "OpenIn" = 1643649331;
      # Safari extensions
      "1password for Sarafi" = 1569813296;
      "Hush" = 1544743900;
      "Noir" = 1592917505;
      "Simplelogin" = 1494051017;
      "SocialFocus" = 1661093205;
      "Surfingkeys" = 1609752330;
      "UnTrap youtube" = 1637438059;
      "Wipr" = 1320666476;
    };
  };
}

