{ inputs, username, hostname, stateVersion, ... }:
{
  networking.hostName = hostname;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { inherit inputs; };
  # home-manager.sharedModules = [ inputs.nixvim.homeManagerModules.nixvim ];
  home-manager.users.${username} = {
    imports = [ 
      ../${hostname}.nix
      (import ../../users/${username}.nix { inherit username stateVersion; })
    ];
  };
}
