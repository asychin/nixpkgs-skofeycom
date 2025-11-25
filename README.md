# nixpkgs-skofeycom

Personal Nix flakes collection.

[![NixOS](https://img.shields.io/badge/NixOS-ready-blue?logo=nixos)](https://nixos.org)
[![Build and Check Flake](https://github.com/asychin/nixpkgs-skofeycom/actions/workflows/ci.yml/badge.svg)](https://github.com/asychin/nixpkgs-skofeycom/actions/workflows/ci.yml)

## 📦 Available Packages

See [PACKAGES.md](PACKAGES.md) for a full list.

- `antigravity` - Google Antigravity IDE
- `waveterm` - Waveterm Terminal

## 🚀 Usage

### 1. Add to `flake.nix`

Add this repository to your inputs. To save space and build time, we recommend reusing your system's `nixpkgs`:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    skofeycom.url = "github:asychin/nixpkgs-skofeycom";
    # Optimization: Use your system's nixpkgs to avoid re-downloading/re-building common dependencies
    skofeycom.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, skofeycom, ... }: {
    # Your configuration...
  };
}
```

### 2. Install Packages

You can install packages directly in your NixOS or Home Manager configuration:

```nix
# In home.nix or configuration.nix
{ pkgs, inputs, ... }: {
  environment.systemPackages = [ # or home.packages
    inputs.skofeycom.packages.${pkgs.system}.antigravity
    inputs.skofeycom.packages.${pkgs.system}.waveterm
  ];
}
```

### ⚡ Quick Run

Run a package without installing:

```bash
nix run github:asychin/nixpkgs-skofeycom#waveterm
# or
nix run github:asychin/nixpkgs-skofeycom#antigravity
```

## 📄 License

MIT License
