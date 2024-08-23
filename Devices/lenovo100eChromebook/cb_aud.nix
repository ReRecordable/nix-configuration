{ config, pkgs, lib, ... }:


let
  cml-ucm-conf = pkgs.alsa-ucm-conf.overrideAttrs {
    wttsrc = pkgs.fetchFromGitHub {
      owner = "WeirdTreeThing";
      repo = "chromebook-ucm-conf";
      rev = "cadc325194f7dbbff6ef29caa589c5f976d4ed2b";
      hash = "sha256-BQfbNV3fPdayodqIyo2lHnekbpFikSS7oz5Nkh60xO4=";
    };
    patches = [];
    #unpackPhase = ''
    #  runHook preUnpack
    #  tar xf "$src"
    #  #tar xf "$wttsrc"
    #  runHook postUnpack
    #'';
    #installPhase = ''
    #  runHook preInstall
    #  mkdir -p $out/share/alsa
    # 
    #  # Debugging commands
    #  echo "Contents of source directory:"
    #  ls -l alsa-ucm*/
    #
    #  echo "Contents of chromebook-ucm directory:"
    #  ls -l chromebook-ucm*/
    #  echo "Contents of chromebook-ucm/alsa-ucm-conf-1.2.11 directory"
    #  ls -l "$wttsrc"/
    #
    #  cp -r alsa-ucm*/{ucm,ucm2} $out/share/alsa
    #  cp -r chromebook-ucm*/common $out/share/alsa/ucm2
    #  cp -r chromebook-ucm*/adl/* $out/share/alsa/ucm2/conf.d
    #  
    #  runHook postInstall
    #'';
    postInstall = ''
        cp -R $wttsrc/sof-rt5682 $out/share/alsa/ucm2/conf.d
        cp -R $wttsrc/common/* $out/share/alsa/ucm2/common
        cp -R $wttsrc/codecs/* $out/share/alsa/ucm2/codecs
        cp -R $wttsrc/platforms/* $out/share/alsa/ucm2/platforms
	cp -R $wttsrc/sof-cs42l42 $out/share/alsa/ucm2/conf.d
    '';
  };
in
{
  boot = {
    extraModprobeConfig = ''
      options snd-intel-dspcfg dsp_driver=3
    '';
  };

  environment = {
    systemPackages = with pkgs; [
      sof-firmware
    ];
    sessionVariables.ALSA_CONFIG_UCM2 = "${cml-ucm-conf}/share/alsa/ucm2";
  };

  system.replaceRuntimeDependencies = [
    ({
      original = pkgs.alsa-ucm-conf;
      replacement = cml-ucm-conf;
    })
  ];
}
