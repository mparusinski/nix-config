#!/bin/sh

MACHINE=$1
echo "Building configuration for machine $MACHINE"
NIX_SSHOPTS="-p 2222" nixos-rebuild switch --flake ./#$MACHINE --build-host mparus@$MACHINE --target-host mparus@$MACHINE --use-remote-sudo
