#!/bin/bash
# Points both binaryTargets in Package.swift at a release's zips, with those zips' checksums.
#
# Usage: scripts/update-package-manifest.sh <version> <directory holding the two .xcframework.zip files>
#
# The release asset URLs are known before the release exists, so the manifest can be committed and
# tagged first and the zips attached to the tag afterwards. Fails if either target was not found,
# rather than tagging a manifest that still points at the previous release.
set -euo pipefail
cd "$(dirname "$0")/.."

VERSION="$1"
ZIPS="$2"

for TARGET in Hopoate HopoateTestingHelpers; do
    ZIP="$ZIPS/$TARGET.xcframework.zip"
    CHECKSUM=$(swift package compute-checksum "$ZIP")
    VERSION="$VERSION" TARGET="$TARGET" CHECKSUM="$CHECKSUM" perl -0pi -e '
        s{(name:\s*"\Q$ENV{TARGET}\E",\s*url:\s*"[^"]*/releases/download/)[^/"]+(/\Q$ENV{TARGET}\E\.xcframework\.zip",\s*checksum:\s*")[0-9a-f]+(")}
         {$1$ENV{VERSION}$2$ENV{CHECKSUM}$3}
    ' Package.swift
    if ! grep -q "download/$VERSION/$TARGET.xcframework.zip" Package.swift \
        || ! grep -q "checksum: \"$CHECKSUM\"" Package.swift; then
        echo "error: Package.swift's $TARGET binaryTarget was not updated." >&2
        exit 1
    fi
    echo "$TARGET -> $VERSION ($CHECKSUM)"
done
