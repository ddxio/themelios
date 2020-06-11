{ ... }:
let
  domain="local";

in {
  imports = [
    ../_common/default.nix
  ];

  networking.hostName = "boron";
  networking.extraHosts = ''
     127.0.0.1 ${domain}
  '';
  #  environment.variables.NIXOS_CONFIG = "/nix-config/hosts/hydrogen/default.nix";
  services.kubernetes = {
    roles = [ "node" ];
    masterAddress = "master.${domain}";
    apiserverAddress = "master.${domain}";
    easyCerts = true;
  };
  services.kubernetes = {
    roles = [ "node" ];
  };
}
