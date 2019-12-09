{ ... }:
{ imports = [
    ../_common/default.nix
  ];

  networking.hostName = "carbon";
  #  environment.variables.NIXOS_CONFIG = "/nix-config/hosts/hydrogen/default.nix";

  bridges =
    {
	    cbr0.interfaces = [ ];
    };

  interface =
    {
	    cbr0 = {
		    ipAddress = "10.10.0.1";
		    prefixLength = 24;
	    };
    };

  services.kubernetes =
    {
      roles = ["master" "node"];
    };

  virtualisation.docker.extraOptions =
    ''--iptables=false --ip-masq=false -b cbr0'';

}
