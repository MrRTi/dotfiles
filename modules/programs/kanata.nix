{ config, lib, pkgs, ... }:
let
  kanata-config-path = ".config/kanata/macbook-iso-keyboard.kbd";
  log-file-dir = "~/.local/share/kanata";

  kanata-run = pkgs.writeShellScriptBin "kanata-run" ''
    #!/usr/bin/env bash
    mkdir -pv ${log-file-dir}

    echo "Requesting sudo password to run kanata..."
    sudo -v || exit 1  # Prompt for password once

    nohup sudo bash -c '
      kanata -q -c ~/${kanata-config-path} -p ${toString config.kanata.port}
    ' > ${log-file-dir}/logfile.log 2>&1 &

    KANATA_PID=$!

    sleep 2

    nohup kanata-layer-monitor > ${log-file-dir}/monitor.log 2>&1 &

    MONITOR_PID=$!

    echo "Started:"
    printf "%-25s %-15s %s\n" "Process" "PID" "Log File"
    printf "%-25s %-15s %s\n" "-------" "---" "--------"

    printf "%-25s %-15s %s\n" "Kanata" "$KANATA_PID" "${log-file-dir}/logfile.log"
    printf "%-25s %-15s %s\n" "Kanata-layer-monitor" "$MONITOR_PID" "${log-file-dir}/monitor.log"

    disown
  '';
in
{
  options = {
    kanata = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
      layer-monitor = lib.mkOption {
        type = lib.types.bool;
        description = "Enable layer monitor in menu bar";
        default = true;
      };
      port = lib.mkOption {
        type = lib.types.port;
        description = "Port";
        default = 4444;
      };
    };
  };

  config = {
    home = lib.mkIf config.kanata.enable {
      packages = with pkgs; [
        kanata
        kanata-run
      ];

      file."${kanata-config-path}".source = ./kanata/macbook-iso-keyboard.kbd;

      # FIXME: Add kanata-layer-monitor build
      file.".config/kanata-layer-monitor/config.yaml"= lib.mkIf config.kanata.layer-monitor {
        text = ''
          host: 127.0.0.1
          port: ${toString config.kanata.port}
          layers:
            base:
              label:
                text: BASE
            symbols:
              label:
                text: SYM
            numbers:
              label:
                text: NUM
            cmd:
              label:
                text: CMD
        '';
      };
    };
  };
}
