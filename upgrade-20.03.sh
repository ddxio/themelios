#!/run/current-system-sw/bin/bash

nix-channel --add https://nixos.org/channels/nixos-20.03 nixos && nixos-rebuild --upgrade boot

