{ ... }:
let
  kubeMasterIP = "192.168.86.201";
  kubeMasterHostname = "api.kube";
  kubeMasterAPIServerPort = 443;
in
{
  imports = [
    ../_common/default.nix
  ];

  networking.hostName = "hydrogen";
  networking.extraHosts = "${kubeMasterIP} ${kubeMasterHostname}";
  #  environment.variables.NIXOS_CONFIG = "/nix-config/hosts/hydrogen/default.nix";
  services.kubernetes = {
    roles = [ "master" "node" ];
    easyCerts = true;
    masterAddress = kubeMasterHostname;
    apiserver = {
      securePort = kubeMasterAPIServerPort;
      advertiseAddress = kubeMasterIP;
    };
    addons.dns.enable = true;
    kubelet.extraOpts = "--fail-swap-on=false";
  };
}
