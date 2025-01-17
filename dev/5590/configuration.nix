# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, modules, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ../../home.nix
      #modules.niri
      ../../con/plymouth.nix
  ];

  # Enable support for those aetherial nix flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Various settings for the boot process.
  boot = {
    kernelModules = [
      "i915"
    ];
    # Enable GRUB and configure it to support EFI
    loader = {
      timeout = 0;
      grub = {
        enable = true;
        efiSupport = true;
        devices = [ "nodev" ];
      };
      efi.canTouchEfiVariables = true;
    };
  };

  # Set the system's hostname. This is the name that the system will go by when it comes to networking.
  networking.hostName = "nix5590";

  # Enable NetworkManager, easiest wifi manager to use. 
  networking.networkmanager.enable = true;

  # Declare fonts that will be available for use on the system.
  fonts.packages = with pkgs; [ font-awesome ultimate-oldschool-pc-font-pack ];

  # Set the time zone that the system will use.
  time.timeZone = "America/New_York";

  # "Locale" config. This option declares what language the system will be in.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # Use "xkb.options" in the tty environment.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # Disable XTerm.
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.desktopManager.xterm.enable = false;
  # Graphics configuration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-sdk
      intel-media-driver
      intel-vaapi-driver
    ];
  };
  # Enable the Niri Compositor
  # programs.niri.enable = true;
  programs.steam.enable = true;
  # The rest of the config for Niri to make it a complete desktop is in "home.nix".

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";
 
  # Define users & their passwords for the system.  users.users = {
  users.users = {
  # Personal Account.
    samantha = {
      description = "To whom which will not be named";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "dialout" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [ ];
    };
  };

  # Allow unfree packages available in the repo to be installed:
  nixpkgs.config.allowUnfree = true;

  # Firefox Nightly overlay.
  # nixpkgs.overlays = [ inputs.firefox.overlays.firefox ];

  # Packages installed system-wide. Search for more at "search.nixos.org" in the "Packages" tab.
  environment.systemPackages = with pkgs; [
    # wget
    git
    google-chrome
    # ecryptfs
    kitty
    neovim
    # waybar
    # wofi
    # wbg
    # swayidle
    # swaylock
    # xwayland-satellite
    # bluetuith
    wl-clipboard
    # dmidecode
    # wirelesstools
    #inputs.nightly.packages.${pkgs.system}.firefox-nightly-bin
    pavucontrol
    # catppuccin
    # catppuccin-gtk
    # catppuccinifier-gui
    nordic
    nordzy-icon-theme
    nordzy-cursor-theme
    # numix-icon-theme-square
    # gruvbox-plus-icons
    btop
    pciutils
    usbutils
    # gtop
    # brightnessctl
    # libgtop
    youtube-music
    # cava
    vesktop
    prismlauncher
    # soteria
    # mako
    # fuzzel
    # playerctl
    # gnome-calculator
    putty
    gnomeExtensions.paperwm
    gnomeExtensions.vertical-workspaces
    gnomeExtensions.dash-to-panel
    gnomeExtensions.arcmenu
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Declare services that will be used on the system. Valid options can be found on "search.nixos.org" in the "NixOS Options" tab.

  # Disable the OpenSSH daemon. Reason: improve security.
  services.openssh.enable = false;

  # Enable "libinput".
  services.libinput.enable = true;

  # Enable Bluetooth support.
  hardware.bluetooth.enable = true;

  # Enable sound support. People paint pipewire as the messiah, i see it more as a annoyance.
  services.pipewire.enable = lib.mkForce false;
  services.pipewire.pulse.enable = lib.mkForce false;
  hardware.pulseaudio.enable = true;

  # Enable Flatpak support.
  services.flatpak.enable = true;
  
  # Enable PolKit to fix an issue with NetworkManager
  security.polkit.enable = true;
  
  # Enable Cloudflare's "warp" proxy.
  services.cloudflare-warp.enable = true;
  
  # Enable Steam
  # programs.steam.enable = true;

  # Disable the NixOS documentation.
  documentation.nixos.enable = false;

  # Options to configure ports controlled by the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Enable the firewall.
  networking.firewall.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value, unless you have did your homework and know what you're doing.
  system.stateVersion = "24.05"; # Did you read the comment?

}

