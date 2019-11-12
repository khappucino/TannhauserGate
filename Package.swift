// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TannhauserGate",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.5.1"),
        .package(url: "https://github.com/apple/swift-nio-ssl.git", from: "2.2.0"),
        .package(url: "https://github.com/apple/swift-nio-http2.git", from: "1.5.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.7.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "TannhauserGate",
            dependencies: ["NIO", "Swinject"]),
        .testTarget(
            name: "TannhauserGateTests",
            dependencies: ["TannhauserGate"]),
    ]
)
