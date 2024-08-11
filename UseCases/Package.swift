// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "UseCases",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "UseCases",
            targets: ["GetUsers"]),
        .library(
            name: "UseCasesImpl",
            targets: ["GetUsersImpl"]),
    ],
    dependencies: [
        .package(path: "../Utils"),
        .package(path: "../Core"),
        .package(path: "../Infrastructure"),
    ],
    targets: [
        .target(
            name: "GetUsers",
            dependencies: [
                .product(name: "Infrastructure", package: "Infrastructure"),
                .product(name: "Utils", package: "Utils"),
                .product(name: "Core", package: "Core"),
            ]
        ),
        .target(
            name: "GetUsersImpl",
            dependencies: [
                "GetUsers",
                .product(name: "Infrastructure", package: "Infrastructure"),
                .product(name: "Utils", package: "Utils"),
                .product(name: "Core", package: "Core"),
            ]
        ),
    ]
)
