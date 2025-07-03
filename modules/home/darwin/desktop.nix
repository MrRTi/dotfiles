{ ... }:
{
  imports = [
    ../../programs.nix
    ./desktop/dock.nix
  ];

  vim.enable = false;
  zsh.enable = false;
}
