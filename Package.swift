// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension Target.Dependency {
    static var tca: Self {
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    }
}

let package = Package(
    name: "swiftui-status-reporting",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "StatusReporting",
            targets: ["StatusReporting"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            .upToNextMajor(from: "1.0.0")
        )
    ],
    targets: [
        .target(
            name: "StatusReporting",
            dependencies: [.tca]
        ),
    ]
)
