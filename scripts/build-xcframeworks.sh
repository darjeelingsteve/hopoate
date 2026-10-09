#!/bin/bash
# Builds Hopoate.xcframework and HopoateTestingHelpers.xcframework for every platform Package.swift
# declares, zips them, and prints the checksum each binaryTarget needs.
#
# Usage: scripts/build-xcframeworks.sh [output-directory]   (default: ./build/xcframeworks)
#
# The zips are what a release attaches. They are not byte-for-byte reproducible, so the checksums
# in Package.swift must be the ones this run prints for the files that are actually uploaded.
set -euo pipefail
cd "$(dirname "$0")/.."

OUT="${1:-build/xcframeworks}"
ARCHIVES="$OUT/archives"
rm -rf "$OUT"
mkdir -p "$ARCHIVES"

# Every destination Package.swift promises, as `xcodebuild -destination` names it.
DESTINATIONS=(
    "generic/platform=iOS"
    "generic/platform=iOS Simulator"
    "generic/platform=macOS,variant=Mac Catalyst"
    "generic/platform=macOS"
    "generic/platform=tvOS"
    "generic/platform=tvOS Simulator"
    "generic/platform=watchOS"
    "generic/platform=watchOS Simulator"
)

for SCHEME in Hopoate HopoateTestingHelpers; do
    FRAMEWORK_ARGS=()
    for DESTINATION in "${DESTINATIONS[@]}"; do
        NAME=$(echo "$DESTINATION" | sed 's|generic/platform=||; s|,variant=| |; s| |-|g')
        ARCHIVE="$ARCHIVES/$SCHEME-$NAME.xcarchive"
        echo "==> $SCHEME for $DESTINATION"
        xcodebuild archive \
            -project Hopoate.xcodeproj \
            -scheme "$SCHEME" \
            -configuration Release \
            -destination "$DESTINATION" \
            -archivePath "$ARCHIVE" \
            SKIP_INSTALL=NO \
            BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
            -quiet
        FRAMEWORK_ARGS+=(-framework "$ARCHIVE/Products/Library/Frameworks/$SCHEME.framework")
    done

    xcodebuild -create-xcframework "${FRAMEWORK_ARGS[@]}" -output "$OUT/$SCHEME.xcframework"
    (cd "$OUT" && zip -qry "$SCHEME.xcframework.zip" "$SCHEME.xcframework")
    echo "$SCHEME checksum: $(swift package compute-checksum "$OUT/$SCHEME.xcframework.zip")"
done
