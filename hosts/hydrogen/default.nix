{ ... }:
let
  hostname = "hydrogen";
  kubeMasterIP = "192.168.86.201";
  kubeMasterHostname = hostname;
  kubeMasterAPIServerPort = 443;
in {
  imports = [
    ../_common/default.nix
  ];

  networking.hostName = hostname;
  networking.extraHosts = ''
    127.0.0.1 ${hostname}
     ${kubeMasterIP} ${kubeMasterHostname}
    '';

  services.kubernetes = {
    roles = [ "master" ];
    easyCerts = true;
    masterAddress = kubeMasterHostname;
    apiserver = {
      securePort = kubeMasterAPIServerPort;
      advertiseAddress = kubeMasterIP;
    };

    # use coredns
    addons.dns.enable = true;

    # needed if you use swap
    kubelet.extraOpts = "--fail-swap-on=false";
  };
}
