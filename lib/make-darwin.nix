{ inputs, stateVersion, self,... }:
{
  mkDarwin = { hostname, username ? "rti", platform ? "aarch64-darwin" }:
  inputs.nix-darwin.lib.darwinSystem {
    specialArgs = {
      inherit platform inputs username hostname stateVersion;
    };
    #extraSpecialArgs = { inherit inputs; }
    modules = [
      {
        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 6;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        nixpkgs.hostPlatform = platform;
        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = [
          (final: _prev: {
            stable = import inputs.nixpkgs-stable { system = platform; };
          })
        ];
      }

      ../modules/darwin.nix
      ../hosts/${hostname}.nix
    ];
  };
}
