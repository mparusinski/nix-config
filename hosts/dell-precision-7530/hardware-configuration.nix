# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."crypt".device = "/dev/disk/by-uuid/02c729ca-f608-4ae8-82ea-b9b5277f0fc7";

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/821b9d89-2f9c-4505-977c-1148f39c2012";
      fsType = "btrfs";
      options = [ "subvol=nixos_root" "compress=zstd" "ssd" "space_cache=v2" "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/821b9d89-2f9c-4505-977c-1148f39c2012";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "ssd" "space_cache=v2" "noatime" ];
    };

  fileSystems."/btr_pool" =
    { device = "/dev/disk/by-uuid/821b9d89-2f9c-4505-977c-1148f39c2012";
      fsType = "btrfs";
      options = [ "subvolid=5" "ssd" "noatime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5E7B-BEAA";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp111s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}