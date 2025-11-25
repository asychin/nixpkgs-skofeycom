{
  description = "Example flake showing how to use waveterm and antigravity from the monorepo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    waveterm = {
      url = "github:asychin/nixpkgs-skofeycom?dir=waveterm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    antigravity = {
      url = "github:asychin/nixpkgs-skofeycom?dir=antigravity";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, waveterm, antigravity, ... }: {
    nixosConfigurations.example = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        waveterm.nixosModules.default
        antigravity.nixosModules.default
        {
          programs.waveterm.enable = true;
          programs.google-antigravity.enable = true;
        }
      ];
    };
  };
}
