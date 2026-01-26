 { config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";

  services.displayManager.gdm.enable = true;
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    displayManager.gdm.wayland = true;
    windowManager.niri = {
      enable = true;
      package = pkgs.niri;
    };
  };

  users.users.yhwach = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "audio" "video" "input" "dialout" "flatpak" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    ghostty
    brave
    emacs
    niri
    noctalia-shell
    firefox
    vlc
    gimp
    inkscape
    libreoffice
    discord
    spotify
    pavucontrol
    blueman
    networkmanagerapplet
    file-roller
    gnome-disk-utility
    gnome-system-monitor
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    (nerd-fonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Printing
  services.printing.enable = true;

  # Enable Flatpak
  services.flatpak.enable = true;
  
  # Add Flathub repository
  systemd.tmpfiles.rules = [
    "d /var/lib/flatpak 0755 root root -"
  ];
  
  # Configure Flatpak remotes
  system.activationScripts.flatpak = ''
    ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  '';

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # NetworkManager applet
  programs.nm-applet.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";

}  
