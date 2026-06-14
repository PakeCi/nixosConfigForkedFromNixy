{
  config,
  pkgs,
  lib,
  ...
}: let
  playitPackage = pkgs.playit-cli;
in {
  fileSystems."/var/lib/minecraft" = {
    device = "/home/raidian/Minecraft/";
    options = ["bind"];
  };

  systemd.services.playit = {
    description = "playittt.gg ye becoz i'm lazy af to do port forward";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${playitPackage}/bin/playit --secret_path /var/lib/playit/secret.toml";
      Restart = "on-failure";
      RestartSec = "30s";
      User = "playit";
      Group = "playit";
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      ReadWritePaths = ["/var/lib/playit"];
      RestrictAddressFamilies = ["AF_INET" "AF_INET6"];
    };
  };

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers.saya-akan-lawan-server = {
      enable = true;
      openFirewall = true;

      package = pkgs.fabricServers.fabric-1_21_1.override {
        loaderVersion = "0.16.5";
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

        "mods/c2me.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/VSNURh3q/versions/wGnmDPvI/c2me-fabric-mc26.1.1-0.3.7%2Balpha.0.63.jar";
          name = "c2me-fabric-mc26.1.1-0.3.7+alpha.0.63.jar";
          hash = "sha256-A9hd3Zt+cY5F4oOZjMmm/4zlimof0AKTJ+QHBYO0Gpw=";
        };
      };
    };
  };
}
