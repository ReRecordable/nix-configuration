{
  description = "NixOS flake; for my personal systems";

  inputs = {
    # nixpkgs unstable 
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # jovian steam deck configuration
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # compiz
    compiz = {
      url = "github:LuNeder/compiz-reloaded-nix/compiz09";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-grub-themes.url = "github:jeslie0/nixos-grub-themes";
    nix-software-center.url = "github:snowfallorg/nix-software-center";
  };

  outputs = { nixpkgs, jovian, ... }@inputs:
  #let
  #  system = "x86_64-linux";
  #in
  {
    # Steam Deck configuration
    nixosConfigurations.nixos-steamdeck = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        #lockfile = builtins.fromJSON (builtins.readFile ./flake.lock);
	modules = {
          jovian = jovian.nixosModules.default;
	};
	inherit inputs;
       };
      modules = [
        ./Devices/valveSteamDeck/configuration.nix
      ];
     };

     # Tower configuration
     nixosConfigurations.thinkcentre-nixos = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       specialArgs = { inherit inputs; };
       modules = [
       ./configuration.nix
       ];
     };
     nixosConfigurations.100e-nixos = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       specialArgs = { inherit inputs; };
       modules = [
       ./Devices/lenovo100eChromebook/configuration.nix
       ];
     };
  };
}
