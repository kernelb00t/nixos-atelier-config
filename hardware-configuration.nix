{ config, modulesPath, lib, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  hardware.enableAllFirmware = true;

  boot.initrd.kernelModules = [
    # Enable for virtualization as host
    # "kvm-intel"

    # Enable for virtualization as guest
    # "virtio_balloon"
    # "virtio_console"
    # "virtio_rng"
  ];

  boot.extraModulePackages = [
  ];

  boot.initrd.availableKernelModules = [
    "9p"
    "9pnet_virtio"
    "ata_piix"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "sr_mod"
    "uhci_hcd"
    "ehci_pci"
    "ahci"
    "firewire_ohci"
    "virtio_blk"
    "virtio_mmio"
    "virtio_net"
    "virtio_pci"
    "virtio_scsi"
    "xhci_pci"
  ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  networking.useDHCP = lib.mkDefault true;
}
