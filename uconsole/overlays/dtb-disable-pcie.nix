{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.hardware.raspberry-pi."4".overlays.disable-pcie;
in {
  options.hardware.raspberry-pi."4".overlays.disable-pcie = {
    enable = mkEnableOption ''overlay enable'';
    name = mkOption {
      type = types.str;
      default = "disable-pcie";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      hardware.deviceTree = {
        overlays = [
          {
            name = "${cfg.name}";
            filter = "bcm2711-rpi-cm4.dtb";
            dtsFile = ./source/disable-pcie.dts;
          }
        ];
      };
    })
  ];
}
