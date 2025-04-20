// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension Target.Dependency {
    static var tca: Self {
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    }
    static var sensoryFeedback: Self {
        .product(name: "SensoryFeedbackClient", package: "swift-sensory-feedback")
    }
}

let package = Package(
    name: "swiftui-status-reporting",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "StatusReporting",
            targets: ["StatusReporting"]),
        .library(
            name: "WindowOverlay",
            targets: ["WindowOverlay"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            .upToNextMajor(from: "1.0.0")
        ),
        .package(
            url: "https://github.com/ratnesh-jain/swift-sensory-feedback",
            .upToNextMajor(from: "0.0.1")
        )
    ],
    targets: [
        .target(
            name: "WindowOverlay",
            dependencies: []
        ),
        .target(
            name: "StatusReporting",
            dependencies: [.sensoryFeedback, .tca, "WindowOverlay"]
        ),
    ]
)
