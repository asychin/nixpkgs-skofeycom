{
  description = "Tabby - A terminal for a more modern age (Nix package)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      flake = {
        # Version information
        version = "1.0.229";

        # Overlay
        overlays.default = final: prev: {
          tabby = final.callPackage ./package.nix { };
        };

        # NixOS Module
        nixosModules.default = import ./modules/nixos.nix;

        # Home Manager Module
        homeManagerModules.default = import ./modules/home-manager.nix;
      };

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Allow unfree packages
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        packages = {
          default = pkgs.callPackage ./package.nix { };
          tabby = pkgs.callPackage ./package.nix { };
        };

        apps.default = {
          type = "app";
          program = "${self'.packages.default}/bin/tabby";
        };
      };
    };
}

