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
        .package(url: "git@github.com:alickbass/CodableFirebase.git", from: "0.2.0"),
        .package(url: "git@github.com:firebase/firebase-ios-sdk.git", from: "9.0.0"),
        .package(path: "../../Frameworks/ASKCore"),
        .package(path: "../../Frameworks/ASKDesignSystem")
    ],
    targets: [
        .target(
            name: "Shared",
            dependencies: [
                "ASKCore",
                "ASKDesignSystem",
                "CodableFirebase",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "OctoKit", package: "octokit.swift")
            ],
            path: "Sources"
        )
    ]
)
