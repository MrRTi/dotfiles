# Added to home manager users username import
{ pkgs, ... }:
let
  # Import all nix files from ./programs
  programsImports = builtins.map
    (file: ./programs + "/${file}")
    (builtins.filter
      (file: builtins.match ".*\\.nix" file != null)
      (builtins.attrNames
        (builtins.readDir ./programs)
      )
    );
in
{
  imports = [
  ] ++ programsImports;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    _1password-cli
    _1password-gui
    ack
    binutils
    cargo
    chatgpt
    cmake
    dive
    dockutil
    du-dust
    glow
    gnumake
    hledger
    jnv
    marksman
    nerd-fonts.jetbrains-mono
    obsidian
    raycast
    tree-sitter
    wget
    yandex-cloud
    yq
  ];
}
