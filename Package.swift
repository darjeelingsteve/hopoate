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
    ],
    dependencies: [],
    targets: [
        .target(name: "Hopoate", dependencies: [], resources: [.copy("Resources/PrivacyInfo.xcprivacy")]),
        .testTarget(name: "HopoateTests", dependencies: ["Hopoate"])
    ],
    swiftLanguageVersions: [.v5]
)
