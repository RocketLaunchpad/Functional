// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Functional",
    products: [
        .library(
            name: "Functional",
            targets: ["Functional"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Functional",
            dependencies: []
        )
    ]
)
