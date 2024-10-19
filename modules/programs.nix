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

  fonts = [
    "JetBrainsMono"
  ];
in
{
  imports = [
  ] ++ programsImports;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    _1password
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
    (nerdfonts.override { fonts = fonts;})
    obsidian
    tree-sitter
    wget
    yandex-cloud
    yq
  ];
}
