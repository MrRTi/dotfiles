{ config, lib, ... }:
let
  defaultGems = ''
    ruby-lsp
    ruby-lsp-rails
  '';
in
{
  options = {
    mise = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      mise = {
        enable = config.mise.enable;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        globalConfig = {
          settings = {
            status = {
              missing_tools = "always";
              show_env = true;
              show_tools = true;
            };
            idiomatic_version_file_enable_tools = ["ruby"];
          };
        };
      };
    };

    home.file.mise-default-gems = {
      target = ".default-gems";
      text = defaultGems;
    };
  };
}
