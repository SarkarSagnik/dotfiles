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

  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
  };

  # Niri window manager (wayland compositor)
  programs.niri = {
    enable = true;
    settings = {
        prefer-no-csd
            input {
                keyboard {
                    xkb {
                        // layout "us"
                        // options "ctrl:nocaps"
                    }
                    numlock
                }

                touchpad {
                    tap
                        natural-scroll
                }

                // Focus follows mouse 
                focus-follows-mouse max-scroll-amount="0%"
            }

        cursor {
            xcursor-theme "Bibata-Modern-Ice"
                xcursor-size 20
        }


        output "eDP-1" {
            mode "1920x1080@144.0"
                scale 1.0
                position x=1280 y=0
        }

        layout {
            gaps 15
                center-focused-column "on-overflow"
                always-center-single-column true

                preset-column-widths {
                    proportion 0.25
                        proportion 0.33333
                        proportion 0.5
                        proportion 0.66667
                        proportion 0.75
                }

            default-column-width {
                proportion 0.5
            }

            focus-ring {
                width 2
                    active-color   "#8aadf4"
                    inactive-color "#363a4f"
            }

            border {
                off
            }

            shadow {
                on
                    softness 30
                    spread 5
                    offset x=0 y=5
                    color "#1e203080"
            }
        }

        spawn-at-startup "xwayland-satellite"
            spawn-at-startup "qs" "-c" "noctalia-shell"
            spawn-at-startup "elephant"

            screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

            hotkey-overlay {
                // skip-at-startup
            }


        animations {
            window-open {
                spring damping-ratio=1.0 stiffness=700 epsilon=0.0001
            }
            window-close {
                spring damping-ratio=1.0 stiffness=700 epsilon=0.1
            }
            window-resize {
                spring damping-ratio=1.0 stiffness=800 epsilon=0.001
            }
            window-movement {
                spring damping-ratio=1.0 stiffness=600 epsilon=0.0001
            }
            overview-open-close {
                spring damping-ratio=1.0 stiffness=900 epsilon=0.0001
            }
            workspace-switch {
                spring damping-ratio=1.0 stiffness=800 epsilon=0.00001
            }
            horizontal-view-movement {
                spring damping-ratio=1.0 stiffness=700 epsilon=0.0001
            }
        }

        // ====================== WINDOW RULES ======================

        // Rounded corners for all windows
        window-rule {
            geometry-corner-radius 12
                clip-to-geometry true
        }

        // Firefox / Helium PiP → floating
        window-rule {
            match app-id=r#"firefox$"# title="^Picture-in-Picture$"
                open-floating true
        }
        window-rule {
            match app-id=r#"helium$"# title="^Picture-in-Picture$"
                open-floating true
        }

        window-rule {
            match app-id=r#"app\.zen_browser\.zen$"# title="^Picture-in-Picture$"
                open-floating true
        }


        // Opacity Rules
        window-rule {
            match is-active=false
                exclude app-id="brave-browser-nightly"
                exclude app-id="helium-browser"
                exclude app-id="google-chrome"
                exclude app-id="Ptyxis"
                opacity 0.80
        }
        window-rule {
            match is-active=true
                opacity 0.95
        }

        // Steam toast notifications → floating bottom-right
        window-rule {
            match app-id=r#"steam$"# title=r#"^notificationtoasts_\d+_desktop$"#
                open-floating true
                default-floating-position x=10 y=10 relative-to="bottom-right"
        }

        // Open browsers maximized
        window-rule {
            match app-id=r#"brave$"#
                match app-id=r#"zen$"#
                match app-id=r#"helium$"#
                open-maximized true
        }

        window-rule {
            match title=r#"nvim$"#
                open-maximized true
        }


        // GNOME apps – proper border drawing
        window-rule {
            match app-id=r#"^org\.gnome\."#
                draw-border-with-background false
        }

        // Centered utilities (tiled, 50% width)
        window-rule {
            match app-id="gnome-control-center"
                match app-id="pavucontrol"
                match app-id="nm-connection-editor"
                default-column-width {
                    proportion 0.5
                }
            open-floating false
        }

        // Wide apps (80% width)
        window-rule {
            match app-id="Spotify"
                match app-id="vesktop"
                match app-id="Code"
                match app-id="zed"
                match app-id="libreoffice"
                default-column-width {
                    proportion 0.8
                }
        }

        // Media apps → "media" workspace, focused
        window-rule {
            match app-id="Spotify"
                match app-id="vesktop"
                open-on-workspace "media"
                open-focused true
        }

        // Floating tools
        window-rule {
            match app-id=r#"^blueman-manager$"#
                match app-id=r#"^xdg-desktop-portal$"#
                match app-id="zoom"
                match app-id="Calculator"
                match app-id="pavucontrol"
                match app-id="speedcrunch"
                match title="Exo Settings"
                open-floating true
        }

        // TUIs
        window-rule {
            match title="tui"
                open-floating true
                default-column-width {
                    fixed 800
                }
            default-window-height {
                fixed 800
            }
        }
        window-rule {
            match title="code-editor-tui"
                default-column-width {
                    fixed 700
                }
            default-window-height {
                fixed 400
            }
        }

        // Terminals – clean borders
        window-rule {
            match app-id="ghostty"
                match app-id="kitty"
                draw-border-with-background false
        }


        // ====================== KEYBINDS ======================

        binds {
            Mod+Shift+Slash { show-hotkey-overlay; }

            Mod+Return { spawn "ghostty"; }
            Mod+D {spawn "walker"; }// { spawn "wofi" "--show" "drun"; }

        // Brightness and Volume controls

        //Volume Up
        XF86AudioRaiseVolume allow-when-locked=true {
            spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+";
        }

        //Volume Down
        XF86AudioLowerVolume allow-when-locked=true {
            spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
        }

        //Volume Mute
        XF86AudioMute allow-when-locked=true {
            spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
        }

        //Mic Mute
        XF86AudioMicMute allow-when-locked=true {
            spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        }


        //Brightness Up
        XF86MonBrightnessUp allow-when-locked=true {
            spawn "brightnessctl" "set" "+10%";
        }

        //Brightness Down
        XF86MonBrightnessDown allow-when-locked=true {
            spawn "brightnessctl" "set" "10%-";
        }


        Mod+O repeat=false { toggle-overview; }
        Mod+Q repeat=false { close-window; }

        Mod+Left { focus-column-left; }
        Mod+H { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+L { focus-column-right; }
        Mod+Up { focus-window-up; }
        Mod+K { focus-window-up; }
        Mod+Down { focus-window-down; }
        Mod+J { focus-window-down; }

        Mod+Ctrl+Left { move-column-left; }
        Mod+Ctrl+H { move-column-left; }
        Mod+Ctrl+Right { move-column-right; }
        Mod+Ctrl+L { move-column-right; }
        Mod+Ctrl+Up { move-window-up; }
        Mod+Ctrl+K { move-window-up; }
        Mod+Ctrl+Down { move-window-down; }
        Mod+Ctrl+J { move-window-down; }

        Mod+Page_Up { focus-workspace-up; }
        Mod+I { focus-workspace-up; }
        Mod+Page_Down { focus-workspace-down; }
        Mod+U { focus-workspace-down; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-window-height; }
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        Mod+F { maximize-column; }
        Mod+Alt+F { fullscreen-window; }
        Mod+C { center-column; }
        Mod+V { toggle-window-floating; }

        Mod+S { screenshot; }
        Mod+Alt+S { screenshot-screen; }
        Mod+Shift+S { screenshot-window; }

        Ctrl+Alt+Delete { quit; }
        Mod+Shift+P { power-off-monitors; }


        // Core apps
        Mod+Shift+F { spawn "nautilus"; }
        Mod+Shift+B { spawn "helium-browser"; }
        Mod+Shift+N { spawn "ghostty" "-e" "nvim"; }

        // System monitors & tools
        Mod+Shift+T { spawn "ghostty" "-e" "btop"; }
        Mod+Shift+D { spawn "ghostty" "-e" "lazydocker"; }

        // Flatpak / frequently used apps
        Mod+Shift+M { spawn "flatpak" "run" "com.spotify.Client"; }
        Mod+Shift+G { spawn "flatpak" "run" "org.signal.Signal"; }
        Mod+Shift+Z { spawn "flatpak" "run" "app.zen_browser.zen"; }
        Mod+Shift+O { spawn "obsidian"; }

        // Quick web shortcuts (URLs must be quoted strings!)
        // Creative & Web Apps
        Mod+Shift+Y { spawn "helium-browser" "--profile-directory=Default" "--app=https://youtube.com"; }
        Mod+Alt+M { spawn "helium-browser" "--profile-directory=Default" "--app=https://music.youtube.com"; }
        Mod+Shift+W { spawn "helium-browser" "--profile-directory=Default" "--app=https://web.whatsapp.com"; }
        Mod+Shift+X { spawn "helium-browser" "--profile-directory=Default" "--app=https://x.com"; }
        Mod+Shift+Alt+X { spawn "helium-browser" "--profile-directory=Default" "--app=https://x.com/compose/post"; }
        Mod+Shift+Alt+F { spawn "helium-browser" "--profile-directory=Default" "--app=https://www.fancode.com"; }

        // Optional (uncomment when you actually have kdenlive installed)
        Mod+Shift+E { spawn "emacs" ; }
        }



        include "./noctalia.kdl"

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
