#!/usr/bin/env nix
#!nix shell nixpkgs#bash nixpkgs#hugo nixpkgs#marp-cli nixpkgs#rsync -c bash
# shellcheck shell=bash

set -euo pipefail
TMPDIR=$(mktemp -d)
chmod 755 "$TMPDIR"

# --- Settings ---
COPY_COMMAND="rsync -avz --delete"
DEPLOY_DEST="collin@teal.terascripting:/services/hugo/www"

# --- Marp ---
MARP_ARGS="--html true"
HUGO_ARGS="--gc --ignoreCache --noBuildLock --panicOnWarning --cleanDestinationDir --destination $TMPDIR"
EXTRA_CSS="div.is-hugo{display:none;content-visibility:hidden;}"

# shellcheck disable=SC2086
hugo build $HUGO_ARGS
for dir in content/presentations/*/; do
    if [ -d "$dir" ]; then
        for file in "$dir"*.md; do
            tmpfile=$(mktemp)
            name="$TMPDIR/presentations/$(basename "$dir")/slides.html"

            cp "$file" "$tmpfile"
            sed -i "s/{{< slides >}}/<style>$EXTRA_CSS<\/style>/g" "$tmpfile"
            sed -i 's/{{<[^>]*>}}//g' "$tmpfile"
            marp "$tmpfile" "$MARP_ARGS" --output "$name"
            rm "$tmpfile"
            
            sed -i 's/<script>/<script nonce="7AnF83KoB">/g' "$name" # Set nonce
            sed -i 's/<head>/<head><meta name="robots" content="noindex">/g' "$name" # Add noindex meta tag
        done
    fi
done

# --- Copy ---
$COPY_COMMAND "$TMPDIR/" "$DEPLOY_DEST"

# --- Cleanup ---
rm -rf "$TMPDIR"

