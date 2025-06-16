{
  description = "RTi Air Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
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
        system.stateVersion = 6;

        nix.package = pkgs.nix;
        nix.settings.sandbox = true;

        # https://github.com/nix-community/lorri
        services.lorri.enable = true;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true;  # default shell on catalina
        programs.fish.enable = true;
      };
    in
      {
      # Build darwin flake using:
      # sudo darwin-rebuild build --flake .#rti-air-m4
      # To apply updated configuration
      # sudo darwin-rebuild switch --flake .#rti-air-m4
      darwinConfigurations."rti-air-m4" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
        };
        modules = [
          configuration
          ./home.nix
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."rti-air-m4".pkgs;
    };
}
