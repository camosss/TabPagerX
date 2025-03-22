// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "TabPagerX",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "TabPagerX", targets: ["TabPagerX"]),
    ],
    targets: [
        .target(name: "TabPagerX"),
        .testTarget(name: "TabPagerXTests", dependencies: ["TabPagerX"]),
    ]
)
