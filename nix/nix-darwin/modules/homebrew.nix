{
  pkgs,
  config,
  username,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  # Install Homebrew under the default prefix
  nix-homebrew.enable = true;
  nix-homebrew.autoMigrate = true;

  # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
  nix-homebrew.enableRosetta = true;

  # User owning the Homebrew prefix
  nix-homebrew.user = username;

  # Optional: Enable fully-declarative tap management
  # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
  nix-homebrew.mutableTaps = false;
  # Optional: Declarative tap management
  nix-homebrew.taps = {
    "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    "homebrew/homebrew-cask" = inputs.homebrew-cask;
    "homebrew/homebrew-core" = inputs.homebrew-core;
    "nikitabobko/homebrew-tap" = inputs.homebrew-aerospace;
  };

  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.upgrade = true;

  homebrew.brews = [
    "mas"
  ];

  homebrew.casks = [
    "bruno"
    "logseq"
    "nikitabobko/tap/aerospace"
    "notion"
    "orbstack"
  ];

  homebrew.masApps = {
    "Endel" = 1346247457;
    "Flow" = 1423210932;
    "Keynote" = 409183694;
    "Numbers" = 409203825;
    "OpenIn" = 1643649331;
    "Owly" = 882812218;
    "Pages" = 409201541;
    "Slack" = 803453959;
    "System color picker" = 1545870783;
    "Telegram" = 747648890;
    "Wireguard" = 1451685025;
    "Yubico Authenticator" = 1497506650;

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
}
