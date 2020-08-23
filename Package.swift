// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSShared",
    platforms: [
        .iOS(.v8),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "iOSShared",
            targets: ["iOSShared"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/SyncServerII/ServerShared.git", .branch("master")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "iOSShared",
            dependencies: [
                .product(name: "iOSServerShared", package: "ServerShared"),
                "Logging"
            ]),
        .testTarget(
            name: "iOSSharedTests",
            dependencies: ["iOSShared"]),
    ]
)
