// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftCommon",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftCommon",
            targets: ["SwiftCommon"]),
    ],
    dependencies: [
        .package(path: "../MetricFetcher/Frameworks/ASKCore"),
    ],
    targets: [
        .target(
            name: "SwiftCommon",
            dependencies: ["ASKCore"],
            path: "Sources"
        )
    ]
)
