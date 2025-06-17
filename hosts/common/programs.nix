# Added to home manager users username import
{ pkgs, ... }:
let
  # Import all nix files from ./programs
  # https://nix-community.github.io/home-manager/options.xhtml
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
    arc-browser
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
    just
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
