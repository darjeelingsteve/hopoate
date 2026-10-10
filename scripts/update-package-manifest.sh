#!/bin/bash
# Points both binaryTargets in Package.swift at a release's zips, with those zips' checksums.
#
# Usage: scripts/update-package-manifest.sh <version> <directory holding the two .xcframework.zip files> <owner/repo>
#
# <owner/repo> is the repository the release is published in (`$GITHUB_REPOSITORY` in the workflow),
# so a fork's release points at the fork's own assets rather than at upstream's.
#
# The release asset URLs are known before the release exists, so the manifest can be committed and
# tagged first and the zips attached to the tag afterwards. Fails if either target was not found,
# rather than tagging a manifest that still points at the previous release.
set -euo pipefail
cd "$(dirname "$0")/.."

VERSION="$1"
ZIPS="$2"
REPOSITORY="$3"

for TARGET in Hopoate HopoateTestingHelpers; do
    ZIP="$ZIPS/$TARGET.xcframework.zip"
    CHECKSUM=$(swift package compute-checksum "$ZIP")
    URL="https://github.com/$REPOSITORY/releases/download/$VERSION/$TARGET.xcframework.zip"
    URL="$URL" TARGET="$TARGET" CHECKSUM="$CHECKSUM" perl -0pi -e '
        s{(name:\s*"\Q$ENV{TARGET}\E",\s*url:\s*")[^"]*/\Q$ENV{TARGET}\E\.xcframework\.zip(",\s*checksum:\s*")[0-9a-f]+(")}
         {$1$ENV{URL}$2$ENV{CHECKSUM}$3}
    ' Package.swift
    if ! grep -qF "url: \"$URL\"" Package.swift \
        || ! grep -q "checksum: \"$CHECKSUM\"" Package.swift; then
        echo "error: Package.swift's $TARGET binaryTarget was not updated." >&2
        exit 1
    fi
    echo "$TARGET -> $VERSION ($CHECKSUM)"
done
