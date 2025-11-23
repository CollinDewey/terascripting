#!/usr/bin/env nix
#!nix shell nixpkgs#bash nixpkgs#marp-cli -c bash
# shellcheck shell=bash

set -euo pipefail

# --- Settings ---
DEPLOY_DEST="./public"
MARP_ARGS="--html true"
EXTRA_CSS="div.is-hugo{display:none;content-visibility:hidden;}"

# --- Build ---
for dir in content/presentations/*/; do
    if [ -d "$dir" ]; then
        for file in "$dir"*.md; do
            tmpfile=$(mktemp)
            cp "$file" "$tmpfile"

            sed -i "s/{{< slides >}}/<style>$EXTRA_CSS<\/style>/g" "$tmpfile"
            sed -i 's/{{<[^>]*>}}//g' "$tmpfile"

            marp "$tmpfile" "$MARP_ARGS" --output "$DEPLOY_DEST/presentations/$(basename "$dir")/slides.html"
            rm "$tmpfile"
        done
    fi
done