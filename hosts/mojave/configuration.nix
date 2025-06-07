{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.configurationLimit = 10;

    networking.hostName = "mojave";
    networking.networkmanager.enable = true;

    time.timeZone = "Australia/Sydney";
    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_GB.UTF-8";
        LC_IDENTIFICATION = "en_GB.UTF-8";
        LC_MEASUREMENT = "en_GB.UTF-8";
        LC_MONETARY = "en_GB.UTF-8";
        LC_NAME = "en_GB.UTF-8";
        LC_NUMERIC = "en_GB.UTF-8";
        LC_PAPER = "en_GB.UTF-8";
        LC_TELEPHONE = "en_GB.UTF-8";
        LC_TIME = "en_GB.UTF-8";
    };

    console.keyMap = "uk";
    services.xserver.xkb = {
        layout = "gb";
        variant = "";
    };

    services.xserver.enable = true;
    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
    };

    programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraPackages = with pkgs; [
            swaylock
            swayidle
            swaybg
            xwayland
        ];
    };
    
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    services.thermald.enable = true;
    services.auto-cpufreq = {
        enable = true;
        settings = {
            battery = {
                governor = "powersave";
                turbo = "never";
            };
            charger = {
                governor = "performance";
                turbo = "auto";
            };
        };
    };

    services.fwupd.enable = true;
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    hardware.opengl = {
        enable = true;
    };

    users.users.tom = {
        isNormalUser = true;
        description = "Tom Atkinson";
        extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
        shell = pkgs.zsh;
    };

    programs.zsh.enable = true;

    environment.systemPackages = with pkgs; [
        # Core utilities
        wget
        curl
        git
        vim
        tree
        htop
        btop
        unzip

        # Wayland utilities
        wl-clipboard
        grim
        slurp
        waybar
        wofi
        mako
        brightnessctl
        swaybg
        swaylock
        swayidle

        # Terminal
        alacritty

        # Network
        networkmanagerapplet
    ];

    # Enable flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nixpkgs.config.allowUnfree = true;

    nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--when-older-than 1w";
    };

    system.stateVersion = "25.05";
}
