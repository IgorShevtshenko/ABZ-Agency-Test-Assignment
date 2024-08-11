// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Nodes",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Nodes",
            targets: [
                "UsersList",
                "SignUpNewUser",
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../UseCases"),
        .package(path: "../Infrastructure"),
        .package(path: "../UILibrary"),
        .package(path: "../Utils"),
    ],
    targets: [
        .target(
            name: "UsersList",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "UseCases", package: "UseCases"),
                .product(name: "Infrastructure", package: "Infrastructure"),
                .product(name: "UILibrary", package: "UILibrary"),
                .product(name: "Utils", package: "Utils")
            ]
        ),
        .target(
            name: "SignUpNewUser",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "UseCases", package: "UseCases"),
                .product(name: "Infrastructure", package: "Infrastructure"),
                .product(name: "UILibrary", package: "UILibrary"),
                .product(name: "Utils", package: "Utils")
            ]
        ),
    ]
)
