# NixOS uConsole support
_just a quick note..._

## recreate the sd-image:
```
nix-build '<nixpkgs/nixos>' -A  config.system.build.sdImage -I nixos-config=sd-image-uConsole.nix
```

## connect to wifi
```
# systemctl start wpa_supplicant.service
# wpa_cli
[...]
```

## enable uconsole-4g-cm4 (disabled by default)
```
hardware.uconsole.module-4g.enable = true;
```
