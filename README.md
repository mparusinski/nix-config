My personal nix-config
======================

![ci-badge](https://img.shields.io/static/v1?label=Built%20with&message=nix&color=blue&style=flat&logo=nixos&link=https://nixos.org&labelColor=111212)

My current repository of NixOS and Home Manager configurations for various
machines.

## File system structure

```
.
.
├── build.sh
├── flake.lock
├── flake.nix
├── modules
│   ├── nixos
│   │   ├── users.nix
│   │   ├── ...
│   │   └── gc.nix
│   └── home-manager
│       ├── git.nix
│       ├── ...
│       └── zsh.nix
└── hosts
    ├── dell-precision-7530
    │   ├── configuration.nix
    │   ├── hardware-configuration.nix
    │   └── home.nix
    └── wsl1
        ├── configuration.nix
        └── home.nix
```

- `build.sh` builds and switches the NixOS and Home-manager
- `flake.nix` defines the list of targets (NixOS and home-manager)
- `modules/nixos` modules for nixos (e.g. configuration of users)
- `modules/home-manager` modules for home-manager (e.g. configuration for user stuff)
- `host/<machine>` directory with the machine configuration (nixos and home-manager)


## Adding a new configuration

To add a new machine :
1. Create a new folder with the (desired) machine name in the `host` subfolder.
2. Copy over from `/etc/nixos/*.nix` to `hosts/<machine>`
3. Add machine name to flake.nix

## Installing

To build a new configuration
```bash
sudo ./build.sh
```

## Upgrading

```bash
nix flake update
sudo ./build.sh
```

Alternatively to build remotely use
```bash
NIX_SSHOPTS="-p 2222" nixos-rebuild switch --flake ./#vps-nix-vpsfreecz --build-host mparus@37.205.10.158 --target-host mparus@37.205.10.158 --use-remote-sudo
```
