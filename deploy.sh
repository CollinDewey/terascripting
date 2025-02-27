#!/usr/bin/env nix
#!nix shell nixpkgs#bash nixpkgs#hugo nixpkgs#marp-cli nixpkgs#rsync -c bash

setopt -euo pipefail
TMPDIR=$(mktemp -d)
chmod 755 $TMPDIR

# --- Settings ---
COPY_COMMAND="rsync -avz --delete"
DEPLOY_DEST="collin@teal.terascripting:/services/hugo/www"

# --- Marp ---
MARP_ARGS="--html true"
HUGO_ARGS="--gc --ignoreCache --noBuildLock --panicOnWarning --cleanDestinationDir --destination $TMPDIR"

# --- Build ---
hugo build $HUGO_ARGS
for dir in content/presentations/*/; do
    if [ -d "$dir" ]; then
        for file in "$dir"*.md; do
            name="$TMPDIR/presentations/$(basename "$file" .md)/slides.html"
            
            marp "$file" $MARP_ARGS --output $name
            sed -i 's/<script>/<script nonce="7AnF83KoB">/g' $file # Set nonce
            sed -i 's/<head>/<head><meta name="robots" content="noindex">/g' $file # Add noindex meta tag
        done
    fi
done

# --- Copy ---
$COPY_COMMAND $TMPDIR/ $DEPLOY_DEST
$POST_DEPLOY_COMMAND

# --- Cleanup ---
rm -rf $TMPDIR

