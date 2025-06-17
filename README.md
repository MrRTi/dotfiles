# Dotfiles

This repos is setup system configuration and dotfiles using nix / nixpkgs / nix-darwin.

## Usage

### To install nix, nix-darwin, home manager, etc

See `install` in `justfile`. 

Or run `just install hostname` if just is installed.
Hostname is optional. By default current system hostname will be used

### To apply configuration after change

See `switch` in `justfile`. 

Or run `just switch hostname` if just is installed.
Hostname is optional. By default current system hostname will be used

## Possible issues

### Remove nix users

```sh
for u in $(sudo dscl . -list /Users | grep _nixbld); do sudo dscl . -delete "/Users/$u"; done
```
### curl error: Problem with the SSL CA cert (path? access rights?)

```sh
sudo rm /etc/ssl/certs/ca-certificates.crt
sudo ln -s /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
```

### /usr/local/Homebrew/Library not exists

```sh
sudo mkdir -pv /usr/local/Homebrew/Library
sudo chown USERNAME /usr/local/Homebrew/Library
```
