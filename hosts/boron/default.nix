{ ... }:
{ imports = [
    ../_common/default.nix
  ];

  networking.hostName = "boron";
#  environment.variables.NIXOS_CONFIG = "/nix-config/hosts/hydrogen/default.nix";
}
