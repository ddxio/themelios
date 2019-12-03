{ ... }:
{ imports = [
    ../_common/default.nix
  ];

  networking.hostName = "carbon";
#  environment.variables.NIXOS_CONFIG = "/nix-config/hosts/hydrogen/default.nix";
}
