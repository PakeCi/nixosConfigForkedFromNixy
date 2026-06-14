{
  config,
  pkgs,
  lib,
  ...
}: let
  playitPackage = pkgs.playit-cli;
in {
  fileSystems."/srv/minecraft" = {
    device = "/home/raidian/Minecraft/";
    options = ["bind"];
  };

  users.users.playit = {
    isSystemUser = true;
    group = "playit";
    home = "/var/lib/playit";
    createHome = true;
  };
  users.groups.playit = {};

  systemd.services.playit = {
    description = "playittt.gg ye becoz i'm lazy af to do port forward";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    #wantedBy = lib.mkForce [];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${playitPackage}/bin/playitd --secret-path /var/lib/playit/secret.toml --socket-path /var/lib/playit/playit.sock";
      Restart = "on-failure";
      RestartSec = "30s";
      User = "playit";
      Group = "playit";
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;

      StateDirectory = "playit";
      RuntimeDirectory = "playit";
      #ReadWritePaths = ["/var/lib/playit" "/run/playit"];
      RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6"];
      Environment = "PLAYIT_SOCKET_PATH=/var/lib/playit/playit.sock";
    };
  };

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers.saya-akan-lawan-server = {
      enable = true;
      openFirewall = true;

      package = pkgs.fabricServers.fabric-1_21_11.override {
        loaderVersion = "0.18.3";
        jre_headless = pkgs.jdk21_headless;
      };

      jvmOpts = lib.concatStringsSep " " [
        "-Xms6G"
        "-Xmx6G"
        "-XX:+UseG1GC"
        "-XX:+ParallelRefProcEnabled"
        "-XX:MaxGCPauseMillis=200"
        "-XX:+UnlockExperimentalVMOptions"
        "-XX:+DisableExplicitGC"
        #"-XX:+AlwaysPreTouch"
        "-XX:G1NewSizePercent=30"
        "-XX:G1MaxNewSizePercent=40"
        "-XX:G1HeapRegionSize=8M"
        "-XX:G1ReservePercent=20"
        "-XX:G1HeapWastePercent=5"
        "-XX:G1MixedGCCountTarget=4"
        "-XX:InitiatingHeapOccupancyPercent=15"
        "-XX:G1MixedGCLiveThresholdPercent=90"
        "-XX:G1RSetUpdatingPauseTimePercent=5"
        "-XX:SurvivorRatio=32"
        "-XX:+PerfDisableSharedMem"
        "-XX:MaxTenuringThreshold=1"
        "-Dusing.aikars.flags=https://mcflags.emc.gs"
        "-Daikars.new.flags=true"
        "-Dfile.encoding=UTF-8"
      ];

      serverProperties = {
        server-port = 25565;
        motd = "hidup jokowi";
        gamemode = "survival";
        difficulty = "normal";
        max-players = 20;
        online-mode = false;
        view-distance = 12;
        simulation-distance = 7;
        network-compression-threshold = 256;
      };

      symlinks = {
        "mods/fabric-api.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/i5tSkVBH/fabric-api-0.141.3%2B1.21.11.jar";
          name = "fabric-api-0.141.3+1.21.11.jar";
          hash = "sha256-hsRTqGE5Zi53VpfQOwynhn9Uc3SGjAyz49wG+Y2/7vU=";
        };

        "mods/skinrestorer.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/TsLS8Py5/versions/MD0HyeAx/SkinsRestorer-Mod-Fabric-15.11.0.jar";
          hash = "sha256-Mm16vluUxqs8D1V7eCij9SK381WfVr3YN4HKa2Rgjko=";
        };

        "mods/lithium.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/Ow7wA0kG/lithium-fabric-0.21.4%2Bmc1.21.11.jar";
          name = "lithium-fabric-0.21.4+mc1.21.11.jar";
          hash = "sha256-UTXEHaW0PL3LKUJL3mUZUUOsQITiODTI6sBllCIBx4s=";
        };

        "mods/ferritecore.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/uXXizFIs/versions/Ii0gP3D8/ferritecore-8.2.0-fabric.jar";
          hash = "sha256-92vXYMv0goDMfEMYD1CJpGI1+iTZNKis89oEpmTCxxU=";
        };

        "mods/tab.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/gG7VFbG0/versions/uWACk3HR/TAB%20v6.0.1.jar";
          name = "TAB-v6.0.1.jar";
          hash = "sha256-KBH6LdjAgLEmlvytE5u7k2CCmxhWXTHjpnCUW7Gsios=";
        };

        "world/datapacks/terralith.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/8oi3bsk5/versions/TFW9ZxPQ/Terralith_1.21.x_v2.5.14.jar";
          hash = "sha256-3mLFiOb5f+KgkjyQVBuRYv7MoPX9h6uusJpevlQg238=";
        };

        "world/datapacks/tectonic.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/lWDHr9jE/versions/7olSYFxL/tectonic-3.0.19-fabric-1.21.11.jar";
          hash = "sha256-p0WQfF8uX9saB4b6Ms4AoDiQ4w8bh+bA6hDKoH3CmtY=";
        };

        "world/datapacks/incendium.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/ZVzW5oNS/versions/dmD183NM/Incendium_26.1_v5.4.12.jar";
          hash = "sha256-1Teuth1+OqPKGMFYVx9oCdPjrs+3DeKTn5Lbx6tIRLE=";
        };
      };
    };
  };
}
