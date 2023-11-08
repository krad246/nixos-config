#!/usr/bin/env bash
set -e

hits="$(mktemp)"
find  . -path ./helpers -prune -o -name '*.nix' -print | tee "$hits" | while read -r F
do
    echo "Checking syntax of '$F'" 1>&2
    nix-instantiate --parse "$F" > /dev/null
done

cat $hits | xargs -I {} deadnix {}
statix check
