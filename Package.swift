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
        .library(name: "Hopoate", targets: ["Hopoate"]),
        .library(name: "HopoateTestingHelpers", targets: ["HopoateTestingHelpers"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "Hopoate",
            url: "https://github.com/darjeelingsteve/hopoate/releases/download/1.14.0/Hopoate.xcframework.zip",
            checksum: "0d9c0415a318284bb2fdd0ba897d9c414e5fb63f3a1649a84c6d3e2c55264552"),
        .binaryTarget(
            name: "HopoateTestingHelpers",
            url: "https://github.com/darjeelingsteve/hopoate/releases/download/1.14.0/HopoateTestingHelpers.xcframework.zip",
            checksum: "482c09b0aa4a0347c54581a9b27b3d3028f34951ac831073ef5128d6e3a520e8"),
    ],
    swiftLanguageVersions: [.v5]
)
