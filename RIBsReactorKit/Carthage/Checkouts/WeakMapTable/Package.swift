// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "WeakMapTable",
  platforms: [
    .macOS(.v10_11), .iOS(.v8), .tvOS(.v9), .watchOS(.v3)
  ],
  products: [
    .library(name: "WeakMapTable", targets: ["WeakMapTable"]),
  ],
  targets: [
    .target( name: "WeakMapTable", dependencies: []),
    .testTarget(name: "WeakMapTableTests", dependencies: ["WeakMapTable"]),
  ]
)
