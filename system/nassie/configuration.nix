# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common/hosts.nix
      ../common/users.nix
      ../common/gc.nix
      ../common/ssh.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nassie"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # This user is for homeassistant automation
  users.users.hass = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOV3DQgtYZK/ohlMaeSw5Jsz3jiUT3C05fmwAGDbpOSh5GpjUrJLraW92kBFeJW2FcTIWZ1MrG3uGErvkn8KhMAvMjk0QKO8Mm3JHXpjKXbGQgRTC/0KCUQtPrXnFB7hlSEsHveeR9/QmshrFTo6WUoc8Wcl4vS/e8RF1F1cohHNsr6N5oPz2tHvh4+ZveFslL8pluERxq2rhrEqUiyryrIa72wG4N1WJprMena3ed1yBpUaAw1+NbcZJb3km+OeuwjY+JMkbvntBMDC+650aydNDRBnS3Zb7Svxt4CAWJYK9LH/T7s/ZyH5OpLuGas4wvOTlmnu1t/FT20PZ7T9A9gYODsc1ISLRgVX9qRpKM3vx5BPWeXwLgxTYPkBlwsGG2xk+kLJeXo/+5gUQVRqK7f9S9IffvH8jMfZM8bFXjwkLK6GJdbSqql6aWWsz6S0tvOykthSRy3JQZ1kUWBOVM6O1Dt6URP2k8ZJiJ3nuu+Qm3JhGlcvVpfp+PXUFOcFU= root@rpi1"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
  ];

  services.btrbk = {
    instances."nas-snapshots" = {
      onCalendar = "hourly";
      settings = {
        snapshot_preserve = "7d";
        snapshot_preserve_min = "3d";
        volume."/btr_pool" = {
          snapshot_dir = "snapshots";
          subvolume = "nas";
        };
      };
    };
  };
  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "${pkgs.coreutils-full}/bin/test";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.coreutils-full}/bin/readlink";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.coreutils-full}/bin/btrfs";
          options = [ "NOPASSWD" ];
        }
      ];
      users = [ "btrbk" ];
    }
    {
      commands = [
        {
          command = "${pkgs.systemd}/bin/poweroff";
          options = [ "NOPASSWD" ];
        }
      ];
      users = [ "hass" ];
    }];
  };

  services.samba = {
    enable = true;
    # You will still need to set up the user accounts to begin with:
    # $ sudo smbpasswd -a yourusername
    
    shares = {
      public = {
        path = "/nas";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
      };
      snapshots = {
        path = "/btr_pool/snapshots";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "no"; 
      };
    };
  };

  # Adding tailscale
  services.tailscale.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 2222 7575 ];
  services.samba.openFirewall = true;

  # Version
  system.stateVersion = "24.05"; # Did you read the comment?
}

