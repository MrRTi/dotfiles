# Install nix-darwin
install:
  curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# Build system to enable darwin
build-system hostname="":
  nix --extra-experimental-features 'nix-command flakes' build ".#darwinConfigurations.{{hostname}}.system"

# Build new revision for flake configuration
build hostname="":
  sudo darwin-rebuild build --flake ".#{{hostname}}"

# Switch to flake configuration
switch hostname="":
  sudo darwin-rebuild switch --flake ".#{{hostname}}"
