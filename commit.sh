#!/usr/bin/env bash

set -x

git add '**/*.nix'
git commit -m "$(date)"

# Push changes
git push origin master

set +x
