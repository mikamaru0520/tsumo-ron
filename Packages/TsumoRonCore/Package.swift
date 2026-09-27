// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TsumoRonCore",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "TsumoRonCore",
            targets: ["TsumoRonCore"]
        )
    ],
    targets: [
        .target(
            name: "TsumoRonCore",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "TsumoRonCoreTests",
            dependencies: ["TsumoRonCore"]
        )
    ]
)
