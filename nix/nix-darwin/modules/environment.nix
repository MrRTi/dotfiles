{ pkgs, inputs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # These packages are available system wide

  environment.systemPackages = with pkgs;
    [
      bat
      fd
      fzf
      git
      hledger
      jq
      mkalias
      neovim
      ripgrep
      tmux
      vim
      wget
      yq
    ];

  environment.variables = {
    EDITOR = "vim";
  };

  environment.shellAliases = {
    ll = "ls -la";
  };
}
