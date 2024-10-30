{pkgs, ...}: {
  nix.distributedBuilds = false;
  nix.settings = {
    substituters = ["https://cache-nix.project2.xyz/uconsole"];
    trusted-substituters = ["https://cache-nix.project2.xyz/uconsole"];
    trusted-public-keys = ["uconsole:t2pv3NWEtXCYY0fgv9BB8r9tRdK+Tz7HYhGq9bXIIck="];
    experimental-features = ["nix-command" "flakes"];
  };
  services.openssh.enable = true;
  environment.systemPackages = [
    pkgs.vim
    pkgs.alejandra
    pkgs.mc
  ];
  boot.supportedFilesystems.zfs = false;
  users.users.oom = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
}
