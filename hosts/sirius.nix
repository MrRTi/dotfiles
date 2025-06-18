{ ... }:
{
  imports = [
    ./common/programs.nix
    ./darwin/dock/desktop.nix
  ];

  mise.enable = false;
  vim.enable = false;
  zsh.enable = false;
}
