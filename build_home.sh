#!/bin/sh

APPLICATION=$(basename "$0")
usage () {
    echo "$APPLICATION [-h/--help] -- Build the Home Manager configuration for machine"
}

VALID_ARGS=$(getopt -o h --long help -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1;
fi

eval set -- "$VALID_ARGS"
while [ : ]; do
    case "$1" in
        -h | --help)
            usage
            exit 0
            shift
            ;;
        --) shift;
            break
            ;;    
    esac
done
            
CONFIG="$(whoami)@$(hostname)"
echo "Building configuration for user $CONFIG"
home-manager --extra-experimental-features "nix-command flakes" switch --flake ./#$CONFIG --show-trace
