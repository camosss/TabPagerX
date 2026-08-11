// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SwiftUITabPager",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "SwiftUITabPager", targets: ["SwiftUITabPager"]),
    ],
    targets: [
        .target(name: "SwiftUITabPager"),
        .testTarget(name: "SwiftUITabPagerTests", dependencies: ["SwiftUITabPager"]),
    ]
)
