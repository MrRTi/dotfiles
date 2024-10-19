{ config, lib, ... }: {
  options = {
    go = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      go = {
        enable = config.go.enable;
        # packages = {
        #   "golang.org/x/text" = builtins.fetchGit "https://go.googlesource.com/text";
        # };
        # goBin = ".local/bin.go"
      };
    };
  };
}
