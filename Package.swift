// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Hopoate",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "Hopoate", type: .dynamic, targets: ["Hopoate"]),
        .library(name: "HopoateTestingHelpers", type: .dynamic, targets: ["HopoateTestingHelpers"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "Hopoate",
            url: "https://github.com/darjeelingsteve/Hopoate/releases/download/1.13.0/Hopoate.xcframework.zip",
            checksum: "e7ac58131fe139fb28031693d1d058538c00e2cbc89b39db3941844d04a69c47"),
        .binaryTarget(
            name: "HopoateTestingHelpers",
            url: "https://github.com/darjeelingsteve/Hopoate/releases/download/1.13.0/HopoateTestingHelpers.xcframework.zip",
            checksum: "4d6e0a5a20d33608e16459dfbbd99843cbaaaae259ea3973e2bdbbcee73c1016"),
    ],
    swiftLanguageVersions: [.v5]
)
