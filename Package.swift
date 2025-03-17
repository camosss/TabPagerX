// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "TabPager",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "TabPager", targets: ["TabPager"]),
    ],
    targets: [
        .target(name: "TabPager"),
        .testTarget(name: "TabPagerTests", dependencies: ["TabPager"]),
    ]
)
