// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "OSet",
    products: [
        .library(name: "OSet", targets: ["OSet"]),
    ],
    targets: [
        .target(name: "OSet", dependencies: [], path: "Sources"),
        .testTarget(name: "OSetTests", dependencies: ["OSet"], path: "Tests/OSetTests"),
    ]
)
