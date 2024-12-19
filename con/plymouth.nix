{ config, pkgs, ... }:

{
  # plymouth.nix - Fancy boot screen!
  boot = {
    plymouth = { 
      enable = true;
      theme = "bgrt";
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=false"
      "splash"
    ];
  };

}
