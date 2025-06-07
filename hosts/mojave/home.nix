{ config, pkgs, ... }:

{
  home.username = "tom";
  home.homeDirectory = "/home/tom";
  home.stateVersion = "25.05";

  home.sessionVariables.EDITOR = "hx";

  # Packages for user
  home.packages = with pkgs; [
    helix
    aerc
    firefox

    nerd-fonts.iosevka
    
    # Additional useful tools
    fd
    ripgrep
    bat
    eza
    zoxide
    fzf
    starship
    
    # Media
    mpv
    imv
    direnv
    
    # Development
    python3
    rustc
    cargo
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Tom Atkinson";
    userEmail = "me@tomatkinson.uk";
    extraConfig = {
      core.editor = "hx";
    };
  };

  # Zsh with starship prompt
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ll = "eza -la";
      ls = "eza";
      cat = "bat";
      find = "fd";
      grep = "rg";
    };
    
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "rust"
        "direnv"
      ];
      theme = "wezm+";
    };
  };

  # Alacritty terminal configuration
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.95;
        blur = true;
      };
      font = {
        normal.family = "Iosevka Nerd Font";
        size = 12;
      };
      colors = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
      };
    };
  };

  # Helix editor configuration
  programs.helix = {
    enable = true;
    settings = {
      theme = "papercolor-dark";
      editor = {
        line-number = "relative";
        mouse = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
        };
      };
    };
  };

  # Firefox configuration
  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "default";
      isDefault = true;
      settings = {
        "browser.startup.homepage" = "about:blank";
        "browser.newtabpage.enabled" = false;
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
      };
    };
  };

  # Waybar configuration for Hyprland
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        
        modules-left = [ "sway/workspaces" "sway/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "battery" "tray" ];
        
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
        
        clock = {
          format = "{:%H:%M %d/%m/%Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
        };
        
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          format-disconnected = "Disconnected ⚠";
        };
        
        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "🔇";
          format-icons = ["🔈" "🔉" "🔊"];
        };
      };
    };
  };

  # Sway configuration
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "wofi --show drun";

      startup = [
        { command = "waybar"; }
        { command = "mako"; }
#        { command = "swaybg -i /home/tom/.config/wallpaper.jpg -m fill"; always = true; }
      ];

      input = {
        "type:keyboard" = {
          xkb_layout = "gb";
        };
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "enabled";
          accel_profile = "adaptive";
          pointer_accel = "0.5";
        };
      };

      output = {
        "*" = {
#          bg = "/home/tom/.config/wallpaper.jpg fill";
        };
      };

      gaps = {
        inner = 5;
        outer = 10;
      };

      window = {
        border = 2;
        hideEdgeBorders = "none";
      };

      colors = {
        focused = {
          border = "#4c7899";
          background = "#285577";
          text = "#ffffff";
          indicator = "#2e9ef4";
          childBorder = "#285577";
        };
        focusedInactive = {
          border = "#333333";
          background = "#5f676a";
          text = "#ffffff";
          indicator = "#484e50";
          childBorder = "#5f676a";
        };
        unfocused = {
          border = "#333333";
          background = "#222222";
          text = "#888888";
          indicator = "#292d2e";
          childBorder = "#222222";
        };
        urgent = {
          border = "#2f343a";
          background = "#900000";
          text = "#ffffff";
          indicator = "#900000";
          childBorder = "#900000";
        };
      };

      keybindings = {
        # Application shortcuts
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec ${menu}";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+f" = "exec firefox";

        # Sway shortcuts
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

        # Focus
        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        # Move
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";

        # Layout
        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+t" = "layout toggle split";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space" = "focus mode_toggle";
        "${modifier}+a" = "focus parent";

        # Fullscreen
        "${modifier}+Shift+f" = "fullscreen toggle";

        # Scratchpad
        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+minus" = "scratchpad show";

        # Screenshots
        # "Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
        # "Shift-Print" = "exec grim | wl-copy";

        # Volume
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec pactl set-souce-mute @DEFAULT_SOURCE@ toggle";

        # Brightness
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
      };

      modes = {
        resize = {
          "Left" = "resize shrink width 10px";
          "Down" = "resize grow height 10px";
          "Up" = "resize shrink height 10px";
          "Right" = "resize grow width 10px";
          "h" = "resize shrink width 10px";
          "j" = "resize grow height 10px";
          "k" = "resize shrink height 10px";
          "l" = "resize grow width 10px";
          "Return" = "mode default";
          "Escape" = "mode default";
        };
      };

      assigns = {
        "2" = [{ app_id = "firefox"; }];
      };

      floating = {
        criteria = [
          { app_id = "pavucontrol"; }
        ];
      };
    };
  };
  
  # Mako notification daemon
  services.mako = {
    enable = true;
    defaultTimeout = 5000;
    backgroundColor = "#1e1e2e";
    textColor = "#cdd6f4";
    borderColor = "#89b4fa";
    borderRadius = 10;
  };

  systemd.user.services.wallpaper = {
    Unit = {
      Description = "Set wallpaper";
      After = [ "sway-session.target" ];
      PartOf = [ "sway-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i %h/.config/wallpaper.jpg -m fill";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "sway-session.target" ];
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
