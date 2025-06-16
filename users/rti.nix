{ username, stateVersion }: { pkgs, inputs, ... }:
let
  gitConfig = {
    name = "Artem Musalitin";
    personal = {
      email = "artem@musalitin.me";
      folderPath = "/Users/${username}/repo/personal";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGiOKXJVCNkbMY0oKSl0ZqaXsXfGDL//wKZ4KP9ZtCP";
    };
  };
in {
  imports = [
    # placeholder
  ];

  git.config = gitConfig;

  home = {
    stateVersion = stateVersion;

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
}
