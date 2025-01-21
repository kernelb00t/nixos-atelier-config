{ config, pkgs, ... }:

{
  # Add Git to the system for fetching repositories
  environment.systemPackages = with pkgs; [ git ];

  # Systemd service to run the script at boot
  systemd.services.fetch-config = {
    description = "Fetch configuration from Git and rebuild if necessary";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "/etc/nixos/fetch-config-and-rebuild.sh";
      Type = "oneshot";
    };
  };

  # Include the script in the NixOS system closure
  environment.etc."nixos/fetch-config-and-rebuild.sh".source = ./fetch-config-and-rebuild.sh;
}