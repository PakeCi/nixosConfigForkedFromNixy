{
  config,
  pkgs,
  ...
}: {
  stylix.targets.kde.enable = false;
  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor.theme = "Breeze_Show";
      cursor.size = 24;
      iconTheme = "Papirus-Dark";
      colorScheme = "BreezeDark";
    };

    kwin = {
      titlebarButtons.left = ["close" "minimize" "maximize"];
      effects = {
        blur.enable = false;
        wobblyWindows.enable = false;
      };
    };

    shortcuts = {
    };

    panels = [
      {
        location = "left";
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontask"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];
  };
}
