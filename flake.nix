{ 
  description = "NixOS Configurations";
  
  inputs = { 
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    jovian.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, nixpkgs, jovian, ... }@inputs: { 
    nixosConfigurations = { 
      "nix-deck" = nixpkgs.lib.nixosSystem {
         system = "x86_64-linux";
         specialArgs = { inherit inputs; };
         modules = [ ./configuration.nix jovian.nixosModules.jovian ];
      };
    };
  };
}
