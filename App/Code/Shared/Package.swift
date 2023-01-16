// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Shared",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Shared",
            targets: ["Shared"])
    ],
    dependencies: [
        .package(url: "https://github.com/nerdishbynature/octokit.swift", from: "0.11.0"),
        .package(path: "../../Frameworks/ASKCore"),
        .package(path: "../../Frameworks/ASKDesignSystem")
    ],
    targets: [
        .target(
            name: "Shared",
            dependencies: [
                "ASKCore",
                "ASKDesignSystem",
                .product(name: "OctoKit", package: "octokit.swift")
            ],
            path: "Sources"
        )
    ]
)
