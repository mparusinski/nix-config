#!/bin/sh

APPLICATION=$(basename "$0")
usage () {
    echo "$APPLICATION [-h/--help] -- Build the NixOS configuration for machine (obtained from hostname)"
}

VALID_ARGS=$(getopt -o h --long help -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1;
fi

MACHINE="$(hostname)"

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
            
echo "Building configuration for machine $MACHINE"
nixos-rebuild switch --flake ./#$MACHINE
