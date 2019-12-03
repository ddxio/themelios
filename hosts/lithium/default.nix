{ ... }:
{ imports = [
    ../_common/default.nix
  ];

  networking.hostName = "lithium";
#  environment.variables.NIXOS_CONFIG = "/nix-config/hosts/hydrogen/default.nix";
}
