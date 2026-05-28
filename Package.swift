// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QuickHatchUI",
    platforms: [.iOS(.v17),
                .watchOS(.v7),
                .macOS(.v14),
                .tvOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "QuickHatchUI",
            targets: ["QuickHatchUI"]),
    ],
    dependencies: [.package(url: "https://github.com/dkoster95/QuickHatchCore.git",
                            from: "1.0.0"),
                   .package(
                       url: "https://github.com/pointfreeco/swift-snapshot-testing",
                       from: "1.19.2"
                     )],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "QuickHatchUI",
            dependencies: ["QuickHatchCore"],
            path: "Sources"),
        .testTarget(
            name: "QuickHatchUITests",
            dependencies: ["QuickHatchUI",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")]
        ),
    ]
)
