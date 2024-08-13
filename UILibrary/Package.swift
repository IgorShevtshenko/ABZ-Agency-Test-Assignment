// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "UILibrary",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "UILibrary",
            targets: ["UILibrary"]),
    ],
    dependencies: [
        .package(path: "../Utils")
    ],
    targets: [
        .target(
            name: "UILibrary",
            dependencies: [
                .product(name: "Utils", package: "Utils"),
            ],
            resources: [
                .copy("Fonts/NunitoSans-Regular.ttf"),
                .copy("Fonts/NunitoSans-SemiBold.ttf"),
                .copy("Resources/Images.xcassets"),
            ]
        ),
        
    ]
)
