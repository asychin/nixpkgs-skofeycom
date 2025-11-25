{
  description = "Skofeycom Nix Packages Collection";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        antigravity = pkgs.callPackage ./antigravity/package.nix { };
        waveterm = pkgs.callPackage ./waveterm/package.nix { };
      });

      nixosModules = {
        antigravity = import ./antigravity/modules/nixos.nix;
        waveterm = import ./waveterm/modules/nixos.nix;
      };

      homeManagerModules = {
        antigravity = import ./antigravity/modules/home-manager.nix;
        waveterm = import ./waveterm/modules/home-manager.nix;
      };
    };
}

