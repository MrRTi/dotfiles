{ pkgs, inputs, username, ... }:
let
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
    ./modules/macos/system-settings.nix
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

    users.${username} = { pkgs, lib, ... }:  {
      imports = [
        ./modules/programs.nix
	      ./modules/macos/dock.nix
      ];

      home = {
        stateVersion = "25.05";

        username = username;
        homeDirectory = "/Users/${username}";

        sessionVariables = {
          # EDITOR = "vim";
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

      vim.enable = false;
      neovim.enable = true;

      local = {
        dock.enable = true;
        dock.entries = [
          { path = "${pkgs.chatgpt}/Applications/ChatGPT.app"; }
          { path = "/System/Applications/Calendar.app"; }
          { path = "/System/Applications/Reminders.app"; }
          { path = "/System/Applications/Notes.app"; }
          { path = "/System/Applications/Mail.app"; }
          # { path = "/Applications/Proton Mail.app"; }
          { path = "${pkgs.wezterm}/Applications/WezTerm.app"; }
          # { path = "/Applications/Arc.app"; }
          { path = "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"; }
          { path = "/Applications/Telegram.app"; }
          { path = "/Applications/LOOP.app"; }
        ];
      };
    };
  };


}
