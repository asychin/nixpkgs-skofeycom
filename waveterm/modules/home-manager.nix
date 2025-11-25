{ config, lib, pkgs, ... }:

let
  cfg = config.programs.waveterm;
in
{
  options.programs.waveterm = {
    enable = lib.mkEnableOption "Waveterm terminal emulator";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ../package.nix { };
      defaultText = lib.literalExpression "pkgs.waveterm";
      description = "The Waveterm package to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
