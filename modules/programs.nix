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

  home.packages = with pkgs; [
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
    gnupg
    hledger
    httpie
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

	nixd
	pyright
	yaml-language-server
  ];
}
