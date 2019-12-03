{ ... }:
{ imports = [
    ../_common/default.nix
  ];

  networking.hostName = "hydrogen";
#  environment.variables.NIXOS_CONFIG = "/nix-config/hosts/hydrogen/default.nix";
}
