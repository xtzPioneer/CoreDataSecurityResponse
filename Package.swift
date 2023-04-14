// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreDataSecurityResponse",
    platforms: [
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .macOS(.v13),
        .macCatalyst(.v16)
    ],
    products: [
        .library(
            name: "CoreDataSecurityResponse",
            targets: ["CoreDataSecurityResponse"]),
    ],
    targets: [
        .target(
            name: "CoreDataSecurityResponse"),
        .testTarget(
            name: "CoreDataSecurityResponseTests",
            dependencies: ["CoreDataSecurityResponse"]),
    ]
)
