{ config, pkgs, ... }:
{
  imports = [];

  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];

  virtualisation =
    {

      # KVM
      libvirtd.enable = true;

      # Docker
      docker = {
        enable = true;
        storageDriver = "devicemapper";
      };

    };

  i18n =
    {
      consoleFont = "Lat2-Terminus16";
      consoleKeyMap = "us";
      defaultLocale = "en_US.UTF-8";
    };

  time.timeZone = "America/New_York";

  programs.mtr.enable = true;

  environment.variables.EDITOR = pkgs.lib.mkOverride 0 "vim";
  programs.bash.enableCompletion = true;

  environment.interactiveShellInit = ''
    export PATH="$PATH:$HOME/bin"
    export PAGER='less --quit-if-one-screen --no-init --ignore-case --RAW-CONTROL-CHARS --quiet --dumb';
    parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/on \1/'
    }
    echo_tmux_title() {
        printf "\033k`whoami`@`pwd`:\033\\"
    }
    shopt -s histappend
    export HISTCONTROL=ignorespace:ignoredups:ignoreboth:erasedups
    export HISTSIZE=300000
    export HISTFILESIZE=200000
    export HISTIGNORE="ls:ll:la:pwd:clear:h:j"
    export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize
    #tmux attach || tmux new
  '';


  # Define user accounts
  users.extraUsers =
    {
      gburd =
        {
          description = "Gregory Burd";
          name = "gburd";
          group = "gburd";
          uid = 1001;
          createHome = true;
          extraGroups = [ "wheel" "networkmanager" "disk" "docker" "systemd-journal" ];
          home = "/home/gburd";
          shell = "/run/current-system/sw/bin/bash";
          isNormalUser = true;
          initialPassword = "password";
        };
    };

  # Define groups for user accounts
  users.extraGroups =
    {
      gburd = {
        gid = 1001;
      };
    };

  # Install some packages
  environment.systemPackages =
    with pkgs;
    [
      curl
      git
      htop
      iotop
      ncdu
      nix-review
      silver-searcher
      tmux
      vim
      kubecfg
      kubectl
      kubectx
      kubetail
      helm
      firecracker
      qemu
      qemu_kvm
      python37Packages.glances
    ];

  services.openssh =
    {
      enable = true;
      permitRootLogin = "yes";
    };

    system.activationScripts.dockerGc = ''
    echo ".*-data(_[0-9]+)?" > /etc/docker-gc-exclude-containers
    echo -e "alpine:.*\ncardforcoin/bitgo-express:.*\nclojure:.*\nmemcached:.*\nnginx:.*\npostgres:.*\npython:.*\nredis:.*\nspotify/docker-gc:.*\ntianon/true\nubuntu:.*" > /etc/docker-gc-exclude
  '';

  # Yubikey
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0113|0114|0115|0116|0120|0402|0403|0406|0407|0410", TAG+="uaccess"
  '';

}
