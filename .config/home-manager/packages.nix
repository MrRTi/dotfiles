# The home.packages option allows you to install Nix packages into your
# environment.
  
pkgs: with pkgs; [
  # # Adds the 'hello' command to your environment. It prints a friendly
  # # "Hello, world!" when run.
  # pkgs.hello

  # # It is sometimes useful to fine-tune packages, for example, by applying
  # # overrides. You can do that directly here, just don't forget the
  # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
  # # fonts?
  # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

  # # You can also create simple shell scripts directly inside your
  # # configuration. For example, this adds a command 'my-hello' to your
  # # environment:
  # (pkgs.writeShellScriptBin "my-hello" ''
  #   echo "Hello, ${config.home.username}!"
  # '')
  (nerdfonts.override { fonts = ["JetBrainsMono"]; })
  bat
  bottom
  broot
  curl
  # direnv
  # docker #
  # docker-compose #
  fontconfig
  fzf
  git
  gitstatus
  hledger
  hledger-ui
  hledger-web
  htop
  jq
  just
  k9s
  # kitty #
  kubectl
  lazygit
  # lorri
  lsd
  neovim
  nixfmt
  nodejs_20
  nodePackages.neovim
  packer
  pandoc
  # podman #
  # podman-compose #
  python310
  python311Packages.pip
  python310Packages.pynvim
  ripgrep
  ruby # gem install neovim
  shellcheck
  tealdeer
  terraform
  tmux
  tree
  tree-sitter
]
