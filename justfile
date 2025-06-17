# Install nix, nix-darwin, apply configuration
install hostname="":
  original_user=$USER

  curl -fsSL https://install.determinate.systems/nix | sh -s -- install
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

  sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .

  sudo mkdir -pv /usr/local/Homebrew/Library
  sudo chown $original_user /usr/local/Homebrew/Library

  sudo ./result/sw/bin/darwin-rebuild switch --flake ".#{{hostname}}"

# Build new revision for flake configuration
build hostname="":
  sudo darwin-rebuild build --flake ".#{{hostname}}"

# Switch to flake configuration
switch hostname="":
  sudo darwin-rebuild switch --flake ".#{{hostname}}"
