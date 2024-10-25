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
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUtNNHFWdEljcTJkazhNRWRzTG85L0lDaTI2YUloalowMGgvN3ZLcml2UWogcm9vdEBuaXhvcwo=";
    }
  ];
  nix.settings.substituters = ["http://nixcache.trustno1.corp/"];
  nix.settings.experimental-features = ["nix-command" "flakes"];

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
