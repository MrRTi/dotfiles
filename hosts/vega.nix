{ ... }:
{
  imports = [
    ./common/programs.nix
    ./darwin/dock/desktop.nix
  ];

  vim.enable = false;
  zsh.enable = false;
}
