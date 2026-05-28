{
  config,
  lib,
  ...
}: {
  imports = [
    # Choose your theme here:
    ../../themes/zen.nix
  ];

  config.var = {
    hostname = "raidian"; # The hostname of your machine, should match the one in flake.nix
    username = "raidian";
    configDirectory =
      "/home/"
      + config.var.username
      + "/.config/nixos-nixy"; # The path of the nixos configuration directory

    keyboardLayout = "us";

    location = "Jakarta";
    timeZone = "Asia/Jakarta";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "id_ID.UTF-8";

    git = {
      username = "PakeCi";
      email = "101933091+PakeCi@users.noreply.github.com";
    };

    autoUpgrade = false;
    autoGarbageCollector = true;
  };

  # DON'T TOUCH THIS
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };
}
