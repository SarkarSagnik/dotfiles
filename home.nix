{ config, pkgs, ... }:

{
  # Required: Set the state version for Home Manager
  home.stateVersion = "25.05";

  # Optional: Enable home-manager (useful if managing shell, etc.)
  programs.home-manager.enable = true;

  # User-specific packages
  home.packages = with pkgs; [
    neovim
    git
    wget
    firefox
    noctalia-shell
    ghostty
    brave
  ];

  # Niri configuration
  programs.niri = {
    enable = true;
    settings = {
      input = {
        keyboard = {
          repeat-delay = 200;
          repeat-rate = 35;
        };
        touchpad = {
          tap-button-map = "left-right-middle";
        };
      };
      outputs = {
        "eDP-1" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.0;
          };
        };
      };
      layout = {
        focus-ring = {
          width = 3;
        };
        border = {
          width = 2;
        };
      };
      prefer-no-csd = true;
    };
  };

  # Noctalia-shell bar configuration
  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        position = "top";
        height = 24;
        background = "#1a1a1a";
        foreground = "#ffffff";
      };
      modules = {
        left = [ "workspaces" ];
        center = [ "clock" ];
        right = [ "battery" "network" "volume" ];
      };
    };
  };

  # Ensure username and home directory are set (recommended when used via NixOS module)
  home.username = "yhwach";
  home.homeDirectory = "/home/yhwach";

  # Shell configuration
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    history.size = 10000;
    shellAliases = {
      ll = "ls -la";
      update = "sudo nixos-rebuild switch --flake /home/yhwach/Documents/nixOS";
      ".." = "cd ..";
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "yhwach";
    userEmail = "yhwach@example.com";
  };

  # Terminal configuration
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "dark";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
      window-opacity = 0.9;
      keybind = [
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
        "ctrl+shift+t=new_tab"
        "ctrl+shift+w=close_tab"
      ];
    };
  };

  # Your other home configuration options go here
}
