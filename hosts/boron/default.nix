{ ... }:
let
  hostname = "boron";
  kubeMasterIP = "192.168.86.201";
  kubeMasterHostname = hostname;
  kubeMasterAPIServerPort = 443;
in
{
  imports = [
    ../_common/default.nix
  ];

  networking.hostName = hostname;
  networking.extraHosts = ''
     127.0.0.1 ${hostname}
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
