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
  #  environment.variables.NIXOS_CONFIG = "/nix-config/hosts/hydrogen/default.nix";

  networking.hostName = "boron";
  networking.extraHosts = ''
     127.0.0.1 ${networking.hostName}
     ${kubeMasterIP} ${kubeMasterHostname}
  '';

  services.kubernetes = let
    api = "https://${kubeMasterHostname}:${kubeMasterAPIServerPort}";
  in
  {
    roles = ["node"];
    masterAddress = kubeMasterHostname;
    easyCerts = true;

    # direct kubelet and other services to kube-apiserver
    kubelet.kubeconfig.server = api;
    apiserverAddress = api;

    # use coredns
    addons.dns.enable = true;

    # needed if you use swap
    kubelet.extraOpts = "--fail-swap-on=false";
  };
}
