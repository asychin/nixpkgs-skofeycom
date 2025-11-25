{
  description = "Waveterm - Open-source, cross-platform terminal";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.callPackage ./package.nix { };
          waveterm = pkgs.callPackage ./package.nix { };
        }
      );

      # NixOS module
      nixosModules.default = import ./modules/nixos.nix;

      # Home Manager module
      homeManagerModules.default = import ./modules/home-manager.nix;

      # Overlay for easy integration
      overlays.default = final: prev: {
        waveterm = final.callPackage ./package.nix { };
      };
    };
}
