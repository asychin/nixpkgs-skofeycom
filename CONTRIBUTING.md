# Contributing Guidelines

We welcome contributions! This repository hosts a collection of independent Nix flakes for various programs.

## How to add a new package
1. **Create a new directory** under the repository root (e.g. `mytool`).
2. Inside that directory add:
   - `flake.nix` – the flake entry point.
   - `package.nix` – Nix expression that builds the software (you can copy the pattern from `waveterm` or `antigravity`).
   - `modules/` – optional NixOS and Home Manager modules (`nixos.nix` and `home-manager.nix`).
3. Update `PACKAGES.md` with a short description, website link, flake URL and a quick‑run command.
4. Run `nix flake check` locally to ensure the flake builds.
5. Open a Pull Request.

## Coding style
- Use `flake-parts` and `treefmt-nix` for formatting.
- Keep Nix code idiomatic – prefer `pkgs.callPackage` and avoid hard‑coded paths.
- Add a `meta` attribute with `description`, `homepage`, `license`, and `maintainers`.

## Testing
We use GitHub Actions to run `nix flake check` on each push. Make sure the CI passes before merging.

## License
All contributions are licensed under the MIT license.
