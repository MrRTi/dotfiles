{ ... }:
let
  homebrewImports = builtins.map
    (file: ./homebrew + "/${file}")
    (builtins.filter
      (file: builtins.match ".*\\.nix" file != null)
      (builtins.attrNames
        (builtins.readDir ./homebrew)
      )
    );
in
{
  imports = [] ++ homebrewImports;

  # Manage homebrew
  homebrew.enable = true;
  # Whether to enable nix-darwin to manage installing/updating/upgrading Homebrew taps, formulae, and casks, as well as Mac App Store apps and Docker containers, using Homebrew Bundle.
  homebrew.onActivation.cleanup = "zap";
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.upgrade = true;

  homebrew.brews = [
    "mas"
  ];

  homebrew.casks = [
    "bruno"
    "logseq"
    "orbstack"
  ];

  homebrew.masApps = {
    "Keynote" = 409183694;
    "Numbers" = 409203825;
    "Pages" = 409201541;
    "System color picker" = 1545870783;

    "Endel" = 1346247457;
    "Flow" = 1423210932;
    "Owly" = 882812218;
    "Slack" = 803453959;
    "Telegram" = 747648890;
    "Wireguard" = 1451685025;
    "Yubico Authenticator" = 1497506650;
  };

  homebrew.extraConfig = ''
    # This file is managed be nix-darwin
  '';

  safari-qol.enable = true;
}
