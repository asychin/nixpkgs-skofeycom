{ config, lib, pkgs, ... }:

let
  cfg = config.programs.tabby;
in
{
  options.programs.tabby = {
    enable = lib.mkEnableOption "Tabby Terminal";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ../package.nix { };
      defaultText = lib.literalExpression "pkgs.tabby";
      description = "The Tabby package to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}

