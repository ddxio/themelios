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

  users.users.root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEk4qMbKX7KUZx4Yaiw4WCPlHP8nXYSZdynq6HwXeXWX Greg Burd <greg@burd.me> - 2018-11-11"];

  users.users.gburd.openssh.authorizedKeys.keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJc2qb1909/uctbx0H2tX8BUOyyXQdxbvsQxDE80PIglc1hqxdf9yUQKCJyywSRyr5TL2KuYJD6UMer58neIlYUhnJ2laPQyb6+kYiQj0/xENpIn6JeLd8yQM48XTyBUW74IwtScPFww80FMSU8tlGcEng7TOdj3O1fLxNPfZZ7yt9+QrRVsmZQ/DxDhMNbnN+fVWV73czQCTzGkbqZ1j4fgE8cLdYgvDEqjgBildK7EsPuLHbSZ/oY0I5xCiiMvRH3tzJ8LMx2maYNXA8HJ9aXORSw3ZcwLgz9YmnRRQYc0ak4b6Uv+Qrw9aZVP7FksuNNdjjG6Moj/nF8fDvzR7vsEIDgj+x09XKYMYquqXbAHMyMrWwvkjUbnL2HwEgbATGkBDrif/7OIoqBzKBCFnI4T7nhDdMbAKmvuU+YUFWbIjYKrMHiGiBoG1LAJ1flN3B0cPefkklse9bp/raUvoftpuZ4EIFxkXnOgNawBh7yNjbMvfLzDxuXrz6lWqFZCnS4IslbL20g6Ur7KjDZcbFC1br7eoUUfBDkVN/oXW+nkWr97nogz1qtqfvyzKt3pNfLd+6TPyU8FLjyVJHzob+aAg0FXmBxQ5kuvAmmmi5gne6p7W+hx69OELLkjJ1Fauqxz1o5I0vxfhqarNrbGoli0OQLclVW9C+2T8kqZfAZQ== gburd@onshape.com"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEk4qMbKX7KUZx4Yaiw4WCPlHP8nXYSZdynq6HwXeXWX Greg Burd <greg@burd.me> - 2018-11-11"
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHJSkptaTw+tFV8cfeqxCRVlnNb8uXvBHmvgpXPmiNhnfZYEJY6mRqH9leAQCORg+yRD0R0ZjWwP1heeOK/ku1Jz2iaiDNxSSd54lg9T+d7AzBkmnIvuA3tIx0mRymWdFBvpznWgwdEdjguiN8nFC/VO7Jy9ddHUj/MoyEUQA+wxdhKddZqPNd8Fdph0K2QDjZ1Cns2/kLYFZhjMY22/ZvRYQYWibqVC5jISVOlo+JEqi/MBH272WHRccwKMoAC1M4xJElEHyxlxu/5USYTx/qg65YrfUNmM6f4F3c9fP74jRYqHXjfRK/Tk5qcMw2a0WFEVZwyyRfULgYwLw8dzIvmkabARtxs3ZnO1+EtdzRI4RH4255QtWx6kMnnnLH3TWXxcGesOEVKVnrISUTBOJD1jaj4FtygrcHq/0ZlicWbp6IRSYbHW0Pr4M3BjQxGXEzB6ekGV29hTF8fXhTWE2jpUSNgwx8j+4PdUgs0k8NSwvAf5mUZejem45bm1QiuI9l6616ml6d7VNAyKX2Q83tCDM5lC2dSkA23w4WdiFrj8Z3JaNHpXN+5jkFjo6Az3deow/m3EGp7I4XbLX6mm115CvtpnE57VDMqxgAMG6XqwhMYZnnlB4CADrR+2T5ohYUJqSjpy3iWp2E2e8afr+eUoRYKDDRnzvXAr/PF30Lgw== greg@blockfi.com"
  ];

  # Install some packages
  environment.systemPackages =
    with pkgs;
    [
      curl
      dig
      firecracker
      git
      gptfdisk
      helm
      htop
      iotop
      kubecfg
      kubectl
      kubectx
      kubetail
      ncdu
      nix-review
      python37Packages.glances
      tig
      qemu
      qemu_kvm
      silver-searcher
      tmux
      vim
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
