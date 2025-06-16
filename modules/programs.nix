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
    ack
    chatgpt
    cmake
    dive
    dockutil
    du-dust
    gcc
    glow
    gnumake
    hledger
    jnv
    marksman
    neovim
    nerd-fonts.jetbrains-mono
    obsidian
    raycast
    tree-sitter
    wget
    yandex-cloud
    yq
  ];
}
