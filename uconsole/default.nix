{
  pkgs,
  nixos-hardware,
  ...
}: let
  rpi-utils = pkgs.callPackage ./packages/rpi-utils {};
in {
  imports =
    [nixos-hardware.nixosModules.raspberry-pi-4]
    ++ [./kernel]
    ++ [./overlays]
    ++ [./packages/overlays]
    ++ [./audio-patch.nix];

  config = {
    environment.systemPackages = [rpi-utils];

    hardware.raspberry-pi."4" = {
      xhci.enable = false;
      dwc2.enable = true;
      dwc2.dr_mode = "host";
      overlays = {
        cpu-revision.enable = true;
        audremap.enable = true;
        vc4-kms-v3d.enable = true;
        disable-pcie.enable = true;
        disable-genet.enable = true;
        panel-uc.enable = true;
        cpi-pmu.enable = true;
        cpi-i2c1.enable = false;
        cpi-spi4.enable = false;
        cpi-bluetooth.enable = true;
      };
    };

    hardware.deviceTree = {
      enable = true;
      filter = "bcm2711-rpi-cm4.dtb";
      overlaysParams = [
        {
          name = "bcm2711-rpi-cm4";
          params = {
            # ant2 = "on";
            audio = "on";
            spi = "off";
            i2c_arm = "on";
          };
        }
        {
          name = "cpu-revision";
          params = {cm4-8 = "on";};
        }
        {
          name = "audremap";
          params = {pins_12_13 = "on";};
        }
        {
          name = "vc4-kms-v3d";
          params = {
            cma-384 = "on";
            nohdmi1 = "on";
          };
        }
      ];
    };

    users.groups.spi = {};
    services.udev.extraRules = ''
      SUBSYSTEM=="spidev", KERNEL=="spidev0.0", GROUP="spi", MODE="0660"
    '';
  };
}
