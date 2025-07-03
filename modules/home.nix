{ username, stateVersion }: { pkgs, inputs, ... }:
{
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
