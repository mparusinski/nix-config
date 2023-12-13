My personal nix-config
======================

![ci-badge](https://img.shields.io/static/v1?label=Built%20with&message=nix&color=blue&style=flat&logo=nixos&link=https://nixos.org&labelColor=111212)

My current repository of NixOS and Home Manager configurations for various
machines.

## File system structure

```
.
.
├── build_home.sh
├── build_system.sh
├── flake.lock
├── flake.nix
├── home
│   ├── home_console.nix
│   ├── home_graphical.nix
│   ├── home_wsl.nix
│   ├── programs
│   └── themes
└── system
    ├── common
    ├── heavens
    ├── nassie
    └── thor
```

- `build_home.sh` builds and switches the home-manager setup for the current machine
- `build_system.sh` builds and switches the NixOS configuration
- `flake.nix` defines the list of targets (NixOS and home-manager)
- `home` directory with the home manager configuration
- `system/common` directory with the common configuration for all machines
- `system/<machine>` directory with the machine configuration

## Installing

To build a new configuration
```bash
sudo ./build_system.sh
```

To build a new home manager configuration
```bash
./build_home.sh
```


