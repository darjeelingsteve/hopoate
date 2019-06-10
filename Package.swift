// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Hopoate",
    products: [
      .library(name: "Hopoate", targets: ["Hopoate"])
    ],
    dependencies: [],
    targets: [
      .target(name: "Hopoate", dependencies: []),
      .testTarget(name: "HopoateTests", dependencies: ["Hopoate"])
    ],
    swiftLanguageVersions: [.v5]
)
