# Used in setup-darvin.nix
{ pkgs, inputs, username, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ./homebrew.nix
    ./system-settings.nix
  ];

  nix.package = pkgs.nix;
  nix.settings.sandbox = true;

  # https://github.com/nix-community/lorri
  services.lorri.enable = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
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
  };
}
