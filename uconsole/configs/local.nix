{pkgs, ...}: {
  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "red";
      systems = ["aarch64-linux"];
      maxJobs = 24;
      speedFactor = 30;
      supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      protocol = "ssh-ng";
    }
  ];
  nix.settings = {
    substituters = ["https://cache-nix.project2.xyz/uconsole" "https://nixcache.trustno1.corp/"];
    trusted-substituters = ["https://cache-nix.project2.xyz/uconsole"];
    trusted-public-keys = ["uconsole:t2pv3NWEtXCYY0fgv9BB8r9tRdK+Tz7HYhGq9bXIIck="];
    experimental-features = ["nix-command" "flakes"];
  };

  services.openssh.enable = true;
  users.users.oom = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
  environment.systemPackages = [
    pkgs.vim
    pkgs.alejandra
    pkgs.mc
  ];
  boot.supportedFilesystems.zfs = false;
}
