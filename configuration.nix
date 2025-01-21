{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/firmware.nix
    ./modules/update.nix
    # ./modules/nix-unstable.nix
    ./modules/flakes.nix
    # ./modules/nixcademy-gdm-logo.nix
    # ./modules/nixcademy-gnome-background.nix
    # ./modules/nixcademy-plymouth-logo.nix
    ./modules/save-space.nix
    # ./modules/virtualization.nix
  ];

  virtualisation.vmware.guest.enable = true;

  system.stateVersion = "24.11";

  # Allow unfree packages to get wifi drivers and other utilities.
  nixpkgs.config.allowUnfree = true;

  # Set your hostname.
  networking.hostName = "mac-kerspace";

  # Enable initrd generation
  boot.initrd.systemd.enable = true;

  # Sets the current kernel to the official Linux.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Set systemd boot as the bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Clean logs
  networking.firewall.logRefusedConnections = false;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";
 
  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";
 
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable Avahi for mDNS (Bonjour) support.
  services.avahi = {
    enable = true;
    ipv4 = true;
    ipv6 = true;
    nssmdns4 = true;
    publish = { 
      enable = true; 
      domain = true; 
      addresses = true; 
    };
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
 
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

    services.xserver = {
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    enable = true;
    libinput.enable = true;
    xkb = {
      layout = "fr";
      variant = "mac";
    };
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    tmux
    unzip
    nano
    firefox
    gimp
    # gnome-calendar
    gnome-user-docs
    gnome-usage
    # gnome-chess
    # gnome-tweaks
    # gnome-clocks
    # gnome-keyring
    # gnome-terminal
    # gnome-weather
    # gnome-contacts
    # gnome-maps
    # gnome-photos
    # gnome-documents
    # gnome-sound-recorder
    # gnome-logs
    # gnome-characters
    # gnome-calculator
    # gnome-system-monitor
    # gnome-disk-utility
    # gnome-control-center
    # gnome-shell-extensions
    inkscape-with-extensions
  ];

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # boot.plymouth.enable = true;

  # customization = {
  #   gdm-logo.enable = true;
  #   gnome-background.enable = true;
  #   plymouth-logo.enable = true;
  # };

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "makerspace";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  hardware.opengl = {
    # this fixes the "glXChooseVisual failed" bug,
    # context: https://github.com/NixOS/nixpkgs/issues/47932
    enable = true;
    driSupport32Bit = true;
  };

  # Loosen security for sudo usage.
  security.sudo.wheelNeedsPassword = false;
  users.mutableUsers = false;

  # Set the password for the root user.
  users.extraUsers.root.password = "makerspace";

  # Define a user account.
  users.users.makerspace = {
    isNormalUser = true;
    description = "makerspace";
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "makerspace";
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  networking.networkmanager.ensureProfiles.profiles."MakerSpace" = {
    connection = {
      id = "MakerSpace";
      permissions = "";
      type = "wifi";
    };
    ipv4 = {
      method = "auto";
    };
    ipv6 = {
      method = "auto";
    };
    wifi = {
      mode = "infrastructure";
      ssid = "MakerSpace";
    };
    wifi-security = {
      key-mgmt = "wpa-psk";
      proto = "rsn";
      psk = "makerspace";
    };
  };
}
