// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "WeakMapTable",
  products: [
    .library(name: "WeakMapTable", targets: ["WeakMapTable"]),
  ],
  targets: [
    .target( name: "WeakMapTable", dependencies: []),
    .testTarget(name: "WeakMapTableTests", dependencies: ["WeakMapTable"]),
  ]
)
