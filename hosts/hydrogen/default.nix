{ ... }:
let
  domain=".local";

in {
  imports = [
    ../_common/default.nix
  ];

  networking.hostName = "hydrogen";
  networking.extraHosts = ''
     127.0.0.1 ${domain}
     127.0.0.1 dashboard.${domain}
     127.0.0.1 master.${domain}
  '';
  #  environment.variables.NIXOS_CONFIG = "/nix-config/hosts/hydrogen/default.nix";
  services.kubernetes = {
    roles = [ "master" ];
    masterAddress = "master.${domain}";
    apiserverAddress = "master.${domain}";
    easyCerts = true;
  };
}
