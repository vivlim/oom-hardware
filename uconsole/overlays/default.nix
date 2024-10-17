{...}: {
  imports = [
    ./dtb-audremap.nix
    ./dtb-cpu-revision.nix
    ./dtb-disable-pcie.nix
    ./dtb-disable-genet.nix
    ./dtb-panel-uc.nix
    ./dtb-cpi-pmu.nix
    ./dtb-cpi-i2c1.nix
    ./dtb-cpi-bluetooth.nix
    ./dtb-vc4-kms-v3d.nix
    ./dtb-cpi-spi4.nix
  ];
}
