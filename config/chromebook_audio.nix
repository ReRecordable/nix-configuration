{ config, pkgs, lib, ... }:

let
  chromebook-ucm-conf = with pkgs; alsa-ucm-conf.overrideAttrs {
    wttsrc = fetchFromGitHub {
      owner = "WeirdTreeThing";
      repo = "chromebook-ucm-conf";
      rev = "cadc325194f7dbbff6ef29caa589c5f976d4ed2b";
      hash = "sha256-BQfbNV3fPdayodqIyo2lHnekbpFikSS7oz5Nkh60xO4=";
    };
    postInstall = ''
       

      for platform in adl apl avs cezanne cml glk jsl mendocino mt8183 picasso stoney; do cp -R $wttsrc/$platform $out/share/alsa/ucm2/conf.d; done;
      cp -R $wttsrc/common/* $out/share/alsa/ucm2/common/
      cp -R $wttsrc/codecs/* $out/share/alsa/ucm2/codecs
      cp -R $wttsrc/platforms/* $out/share/alsa/ucm2/platforms
      cp -R $wttsrc/sof-rt5682 $out/share/alsa/ucm2/conf.d
      cp -R $wttsrc/sof-cs42l42 $out/share/alsa/ucm2/conf.d

      echo "Listing the contents of 'share/alsa/'."
      ls $out/share/alsa/
      echo "Listing the contents of 'share/alsa/ucm2/'."
      ls $out/share/alsa/ucm2/
      echo "Listing the contents of 'share/alsa/ucm2/platforms/'."
      ls $out/share/alsa/ucm2/platforms/
      echo "Listing the contents of 'share/alsa/ucm2/codecs/'."
      ls $out/share/alsa/ucm2/codecs/
      echo "Listing the contents of 'share/alsa/ucm2/conf.d/'."
      ls $out/share/alsa/ucm2/conf.d/
      sleep 30s
    '';
  };
in
{
  environment = {
    systemPackages = with pkgs; [
      sof-firmware
    ];
    #sessionVariables.ALSA_CONFIG_UCM2 = "${chromebook-ucm-conf}/share/alsa/ucm2";
  }; 
  boot.extraModprobeConfig = ''
    options snd-sof-pci fw_path="intel/sof"
    options snd-intel-dspcfg dsp_driver=3
  '';
  system.replaceRuntimeDependencies = with pkgs; [
    ({
      original = alsa-ucm-conf;
      replacement = chromebook-ucm-conf;
    })
  ];

  # For nixos unstable
  services.pipewire.wireplumber.configPackages = [
    (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-increase-headroom.conf" ''
      monitor.alsa.rules = [
        {
          matches = [
            {
              node.name = "~alsa_output.*"
            }
          ]
          actions = {
            update-props = {
              api.alsa.headroom = 8192
            }
          }
        }
      ]
    '')
  ];
}
