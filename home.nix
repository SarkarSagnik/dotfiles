{ config, pkgs, ... }:

{
  # Required: Set the state version for Home Manager
  home.stateVersion = "25.11";

  # Optional: Enable home-manager (useful if managing shell, etc.)
  programs.home-manager.enable = true;

  # User-specific packages
  home.packages = with pkgs; [
    neovim
    git
    wget
    firefox
  ];

  # Ensure username and home directory are set (recommended when used via NixOS module)
  home.username = "yhwach";
  home.homeDirectory = "/home/yhwach";

  # Example: Enable Zsh (optional)
  # programs.zsh.enable = true;

  # Your other home configuration options go here
}
