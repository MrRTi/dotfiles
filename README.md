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

### Configuring git using includeIf

```bash
just build-git-includes "personal-folder-name:personal@email.com;work-folder-name:work@work-email.com"
```

This command will create `.gitconfig` files in `~/Developer/personal-folder-name` and `~/Developer/work-folder-name` with different emails and signing keys. These files will be included using `includeIf` into `~/.git-includes.gitconfig`

Public keys for signing will be read from ssh-agent using provided email e.g.

```bash
$ ssh-add -L
ssh-ed25519 AA*******P personal@email.com # will be used as signing key for personal-folder-name
ssh-ed25519 AA*******d work@work-email.com # will be used as signing key for work-folder-name
```

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
