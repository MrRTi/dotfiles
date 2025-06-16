{ config, lib, ... }: {
  options = {
    vim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      vim = {
        enable = config.vim.enable;
      };
    };
  };
}
