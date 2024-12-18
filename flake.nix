{
  description = "oom-hardware";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  outputs = {
    nixpkgs,
    nixos-hardware,
    ...
  }: let
    system = "aarch64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    nixosModules = {
      uconsole = import ./uconsole {inherit pkgs nixos-hardware;};
      deskpi = import ./deskpi {inherit pkgs nixos-hardware;};
    };
    uconsole = {
      default = ./uconsole;
      sdImage = ./uconsole/sd-image-uConsole.nix;
      kernel = ./uconsole/kernel;
    };
    raspberry-pi = {
      overlays = ./raspberry-pi/overlays;
      apply-overlays = ./raspberry-pi/apply-overlays;
      rpi-utils = ./raspberry-pi/packages/rpi-utils;
    };
  };
}
