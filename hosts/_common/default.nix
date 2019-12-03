{ config, pkgs, ... }:
{
  imports = [];

  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  virtualisation.libvirtd.enable = true;

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "America/New_York";

  programs.mtr.enable = true;
  programs.bash.enableCompletion = true;

  environment.systemPackages = with pkgs; [
    curl git vim
  ];

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

}
