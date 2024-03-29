# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b0b43059-b5f0-4ea7-8f59-ff84ea089d22";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-457204f5-9368-4754-9eaf-56f722155b3b".device = "/dev/disk/by-uuid/457204f5-9368-4754-9eaf-56f722155b3b";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6FC3-32C9";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/3e379b55-0da0-48c8-a651-e6e5fea11634";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-5adcdee3-e73e-4a06-95f0-3f4331261852".device = "/dev/disk/by-uuid/5adcdee3-e73e-4a06-95f0-3f4331261852";

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
