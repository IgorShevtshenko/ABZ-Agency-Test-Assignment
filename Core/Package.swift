// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Core",
            targets: [
                "Domain",
                "Architecture"
            ]
        ),
    ],
    targets: [
        .target(name: "Domain"),
        .target(name: "Architecture")
    ]
)
