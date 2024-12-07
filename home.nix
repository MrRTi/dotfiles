{ config, pkgs, inputs, ... }:
let

  username = "rti";
  name = "Artem Musalitin";

  homeDirectory = "/Users/${username}";

  gitConfig = {
    name = name;
    personal = {
      email = "artem@musalitin.me";
      folderPath = "${homeDirectory}/repo/personal";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGiOKXJVCNkbMY0oKSl0ZqaXsXfGDL//wKZ4KP9ZtCP";
    };
  };
in {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ./modules/homebrew.nix
  ];

  environment.systemPackages = with pkgs; [
    mkalias
    zsh
    fish
  ];

  environment.shells = with pkgs; [
    fish
    zsh
  ];

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    isHidden = false;
    shell = pkgs.fish;
    # NOTE: https://github.com/LnL7/nix-darwin/issues/811#issuecomment-2227415650
    uid = 501;
  };
  # NOTE: https://github.com/LnL7/nix-darwin/issues/811#issuecomment-2227415650
  users.knownUsers = [ username ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${username} = { pkgs, ... }:  {
      imports = [
        ./modules/programs.nix
      ];

      home = {
        stateVersion = "24.05";

        username = username;
        homeDirectory = "/Users/${username}";

        sessionVariables = {
          EDITOR = "vim";
        };

        shellAliases = {
          ll = "ls -la";
          ":q" = "exit";
          clean_desktop="rm ~/Desktop/*.png";
        };
      };

      fish.enable = true;
      zsh.enable = false;
      starship.enable = true;

      git.enable = true;
      git.config = gitConfig;

      # TODO: configure neovim
      neovim.enable = false;
    };
  };
}
