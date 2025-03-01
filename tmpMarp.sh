#!/usr/bin/env nix
#!nix shell nixpkgs#bash nixpkgs#marp-cli -c bash

# --- Settings ---
DEPLOY_DEST="./public"
MARP_ARGS="--html true"

# --- Build ---
for dir in content/presentations/*/; do
    if [ -d "$dir" ]; then
        for file in "$dir"*.md; do
            tmpfile=$(mktemp)
            cp $file $tmpfile

            sed -i 's/{{<[^>]*>}}//g' "$tmpfile"

            marp "$tmpfile" $MARP_ARGS --output "$DEPLOY_DEST/presentations/$(basename $dir)/slides.html"
            rm "$tmpfile"
        done
    fi
done