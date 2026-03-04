#!/bin/bash
set -e

VERSION_FILE="scripts/!mods_preload/!register_mod_nggh_magic_concept.nut"

create_zip() {
    rm -f mod_mc.zip
    zip -r mod_mc.zip . -x 'release.sh' -x '*.git*' -x '*.zip*'
}

update_version() {
    local new_version="$1"
    sed -i "s/Version = \"[^\"]*\",/Version = \"$new_version\",/" "$VERSION_FILE"
    if grep -q "Version = \"$new_version\"," "$VERSION_FILE"; then
        echo "Version updated successfully to $new_version"
    else
        echo "Error: Failed to update version in $VERSION_FILE"
        exit 1
    fi
}

if [ -z "$1" ]; then
    create_zip
else
    NEW_VERSION="$1"

    if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Error: Invalid version format. Expected format: X.Y.Z (e.g., 1.9.7)"
        exit 1
    fi

    update_version "$NEW_VERSION"

    git add "$VERSION_FILE"
    git commit -m "Bump version to $NEW_VERSION"

    TAG="$NEW_VERSION"
    git tag "$TAG"
    git push origin main
    git push origin "$TAG"

fi
