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
    targets: [
        .target(
            name: "UILibrary",
            resources: [
                .copy("Fonts/NunitoSans-Regular.ttf"),
                .copy("Fonts/NunitoSans-SemiBold.ttf"),
                .copy("Resources/Images.xcassets"),
            ]
        ),
        
    ]
)
