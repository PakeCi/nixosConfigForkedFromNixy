{config, ...}: {
  imports = [
    # Mostly system related configuration
    ../../nixos/nvidia.nix # CHANGEME: Remove this line if you don't have an Nvidia GPU
    ../../nixos/audio.nix
    ../../nixos/bluetooth.nix
    ../../nixos/fonts.nix
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ../../nixos/systemd-boot.nix
    ../../nixos/sddm.nix
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ../../nixos/hyprland.nix
    ../../nixos/docker.nix
    ../../nixos/clamav.nix

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # User definition with empty password
  users.users.${config.var.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    password = "1234";
  };

  programs.kdeconnect.enable = true;

  services.flatpak.enable = true;

  system.activationScripts.postActivation.text = ''
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  '';

  nixpkgs.config.allowUnfree = true;

  # Don't touch this
  system.stateVersion = "24.05";
}
