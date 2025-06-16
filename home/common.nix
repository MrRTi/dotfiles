{ pkgs, inputs, username, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../modules/homebrew.nix
    ../modules/macos/system-settings.nix
  ];

  nix.package = pkgs.nix;
  nix.settings.sandbox = true;

  # https://github.com/nix-community/lorri
  services.lorri.enable = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;

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
}
