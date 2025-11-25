# nixpkgs-skofeycom

Personal Nix flakes collection. Each package is an independent flake.

[![NixOS](https://img.shields.io/badge/NixOS-ready-blue?logo=nixos)](https://nixos.org)

## 📦 Available Packages

See [PACKAGES.md](PACKAGES.md) for a list of available software and descriptions.

## 🚀 Installation

You can add individual packages to your configuration using the `?dir=` syntax.

### NixOS Configuration

Add to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Example: Adding Waveterm
    waveterm = {
      url = "github:asychin/nixpkgs-skofeycom?dir=waveterm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, waveterm, ... }: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the module
        waveterm.nixosModules.default
        {
          # Enable the program
          programs.waveterm.enable = true;
        }
      ];
    };
  };
}
```

### Home Manager Configuration

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    
    # Example: Adding Waveterm
    waveterm = {
      url = "github:asychin/nixpkgs-skofeycom?dir=waveterm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, waveterm, ... }: {
    homeConfigurations.your-user = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        # Import the module
        waveterm.homeManagerModules.default
        {
          # Enable the program
          programs.waveterm.enable = true;
        }
      ];
    };
  };
}
```

### Quick Run

You can run any package without installing it:

```bash
nix run github:asychin/nixpkgs-skofeycom?dir=waveterm
```

## 📄 License

MIT License
