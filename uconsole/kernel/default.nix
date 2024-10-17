{
  nixpkgs,
  pkgs,
  config,
  ...
}: let
  kernelPackagesCfg = {
    linuxPackagesFor,
    linux_rpi4,
    fetchFromGitHub,
  }: let
    # Version picked from the current (as of 8th Oct 2024) nixpkgs-unstable branch
    modDirVersion = "6.6.31";
    tag = "stable_20240529";
  in
    linuxPackagesFor (linux_rpi4.override {
      argsOverride = {
        version = "${modDirVersion}-${tag}-cpi";
        inherit modDirVersion;

        src = fetchFromGitHub {
          owner = "raspberrypi";
          repo = "linux";
          rev = tag;
          hash = "sha256-UWUTeCpEN7dlFSQjog6S3HyEWCCnaqiUqV5KxCjYink=";
        };
      };
    });
  patches = [
    ./patches/001-OCP8178-backlight-driver.patch
    ./patches/002-clockwork-cwu50.patch
    ./patches/003-axp20x-power.patch
    ./patches/004-vc4_dsi-update.patch
    ./patches/005-bcm2835-audio-staging.patch
  ];
in {
  boot.kernelPackages = pkgs.callPackages kernelPackagesCfg {};

  #  boot.initrd.kernelModules = [
  #    "ocp8178_bl"
  #    "panel-cwu50"
  #  ];

  boot.kernelPatches =
    (
      builtins.map (patch: {
        name = patch + "";
        patch = patch;
      })
      patches
    )
    ++ [
      {
        name = "uconsole-config";
        patch = null;
        extraStructuredConfig = {
          DRM_PANEL_CWU50 = pkgs.lib.kernel.module;
          DRM_PANEL_CWD686 = pkgs.lib.kernel.module;
          # SIMPLE_AMPLIFIER_SWITCH = pkgs.lib.kernel.module;
          BACKLIGHT_OCP8178 = pkgs.lib.kernel.module;

          REGMAP_I2C = pkgs.lib.kernel.yes;
          INPUT_AXP20X_PEK = pkgs.lib.kernel.yes;
          CHARGER_AXP20X = pkgs.lib.kernel.module;
          BATTERY_AXP20X = pkgs.lib.kernel.module;
          AXP20X_POWER = pkgs.lib.kernel.module;
          MFD_AXP20X = pkgs.lib.kernel.yes;
          MFD_AXP20X_I2C = pkgs.lib.kernel.yes;
          REGULATOR_AXP20X = pkgs.lib.kernel.yes;
          AXP20X_ADC = pkgs.lib.kernel.module;
          TI_ADC081C = pkgs.lib.kernel.module;
          CRYPTO_LIB_ARC4 = pkgs.lib.kernel.yes;
          CRC_CCITT = pkgs.lib.kernel.yes;
        };
      }
    ];
}
