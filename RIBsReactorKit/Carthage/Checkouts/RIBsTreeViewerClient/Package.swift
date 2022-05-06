// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "RIBsTreeViewerClient",
    platforms: [.iOS(.v8)],
    products: [
        .library(name: "RIBsTreeViewerClient", targets: ["RIBsTreeViewerClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.2.0"),
        .package(url: "https://github.com/uber/RIBs.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "RIBsTreeViewerClient",
            dependencies: ["RxSwift", "RxCocoa", "RIBs"],
            path: "./RIBsTreeViewerClient/Sources"
        )
    ]
)
