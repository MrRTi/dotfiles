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
    cmake
    dive
    du-dust
    gcc
    glow
    gnumake
    hledger
    jnv
    kitty
    marksman
    neovim
    nerd-fonts.jetbrains-mono
    obsidian
    tree-sitter
    wget
    yandex-cloud
    yq
  ];
}
