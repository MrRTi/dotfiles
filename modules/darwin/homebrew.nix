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
  homebrew.extraConfig = ''
    # This file is managed be nix-darwin
  '';

  safari-qol.enable = true;
}
