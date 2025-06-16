{ ... }:
{
  imports = [
    ./common/programs.nix
    ./darwin/dock/desktop.nix
  ];

  fish.enable = true;
  git.enable = true;
  neovim.enable = true;
  starship.enable = true;
  vim.enable = false;
  zsh.enable = false;
}
