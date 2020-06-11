#!/run/current-system/sw/bin/bash

cd /nix-config && git fetch && git pull && nix-channel --update && nixos-rebuild switch && reboot

