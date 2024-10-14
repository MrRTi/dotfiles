{
  description = "RTi Air Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # Optional: Declarative tap management
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-aerospace = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };

  };

  outputs = { self, nix-darwin, nixpkgs, ... } @ inputs:
    let
      username = "rti";
      platform = "aarch64-darwin";

      stableOverlay = final: _prev: {
        stable = import inputs.nixpkgs-stable {
          system = platform;
        };
      };

      configuration = { pkgs, config, ... }: {
        nixpkgs.hostPlatform = platform;
        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = [
          stableOverlay
        ];

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 5;

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;
        nix.package = pkgs.nix;
        nix.settings.sandbox = true;

        # https://github.com/nix-community/lorri
        services.lorri.enable = true;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";
      };
    in
      {
      # Build darwin flake using:
      # darwin-rebuild build --flake .#air
      # To apply updated configuration
      # darwin-rebuild switch --flake .#air
      darwinConfigurations."air" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
        };
        modules = [
          configuration
          ./modules/macos-system.nix
          ./modules/fonts.nix
          ./modules/programs.nix
          ./modules/homebrew.nix
          ./modules/users.nix
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."air".pkgs;
    };
}
