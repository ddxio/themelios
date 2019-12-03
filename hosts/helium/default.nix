{ ... }:
{ imports = [
    ../_common/default.nix
  ];

  networking.hostName = "helium";
#  environment.variables.NIXOS_CONFIG = "/nix-config/hosts/hydrogen/default.nix";
}
