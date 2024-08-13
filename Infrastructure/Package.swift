// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Infrastructure",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Infrastructure",
            targets: [
                "UsersRepository",
                "NetworkClient",
                "PhoneNumberService",
                "PositionsRepository",
                "AuthenticationTokenRepository",
            ]),
        .library(
            name: "InfrastructureImpl",
            targets: [
                "UsersRepositoryImpl",
                "NetworkClientImpl",
                "PhoneNumberServiceImpl",
                "PositionsRepositoryImpl",
                "AuthenticationTokenRepositoryImpl"
            ]),
    ],
    dependencies: [
        .package(path: "../Utils"),
        .package(path: "../Core"),
        .package(
            url: "https://github.com/marmelroy/PhoneNumberKit.git",
            .upToNextMinor(from: "3.8.0")
        ),
    ],
    targets: [
        .target(
            name: "UsersRepository",
            dependencies: [
                .product(name: "Utils", package: "Utils"),
                .product(name: "Core", package: "Core"),
            ]
        ),
        .target(
            name: "UsersRepositoryImpl",
            dependencies: [
                "UsersRepository",
                "NetworkClient",
                .product(name: "Utils", package: "Utils"),
                .product(name: "Core", package: "Core"),
            ]
        ),
        .target(
            name: "NetworkClient",
            dependencies: [.product(name: "Utils", package: "Utils")]
        ),
        .target(
            name: "NetworkClientImpl",
            dependencies: [
                "NetworkClient",
                "AuthenticationTokenRepository",
                .product(name: "Utils", package: "Utils"),
            ]
        ),
        .target(
            name: "PhoneNumberService",
            dependencies: [
                .product(name: "Core", package: "Core"),
            ]
        ),
        .target(
            name: "PhoneNumberServiceImpl",
            dependencies: [
                "PhoneNumberService",
                "PhoneNumberKit",
                .product(name: "Core", package: "Core"),
            ]
        ),
        .target(
            name: "PositionsRepository",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Utils", package: "Utils"),
            ]
        ),
        .target(
            name: "PositionsRepositoryImpl",
            dependencies: [
                "PositionsRepository",
                "NetworkClient",
                .product(name: "Core", package: "Core"),
                .product(name: "Utils", package: "Utils"),
            ]
        ),
        .target(
            name: "AuthenticationTokenRepository"
        ),
        .target(
            name: "AuthenticationTokenRepositoryImpl",
            dependencies: [
                "AuthenticationTokenRepository"
            ]
        ),
    ]
)
