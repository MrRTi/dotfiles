# ~/.config/home-manager/home.nix

{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "rti";
  home.homeDirectory = "/Users/rti";
  #
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = import ./packages.nix pkgs; 
  home.file = import ./files.nix;
  home.sessionVariables = import ./env_vars.nix; 

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
