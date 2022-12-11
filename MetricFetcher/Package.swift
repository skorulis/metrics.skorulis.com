// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MetricFetcher",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "git@github.com:nerdishbynature/octokit.swift.git", from: "0.11.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "git@github.com:skorulis/ASKCore.git", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "MetricFetcher",
            dependencies: [
                .product(name: "OctoKit", package: "octokit.swift"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "ASKCore"
            ],
            path: "Sources"
            )
        
    ]
)
