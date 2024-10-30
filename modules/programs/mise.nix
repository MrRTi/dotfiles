{ config, lib, ... }:
let
  defaultGems = ''
solargraph
solargraph-rails
rubocop
rubocop-rails
rubocop-rspec
rubocop-performance
rubocop-factory_bot
rubocop-rspec_rails
reek
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
