{ username }: { pkgs, inputs, ... }:
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
  git.config = gitConfig;
}
