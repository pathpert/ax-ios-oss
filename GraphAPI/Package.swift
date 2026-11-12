// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "GraphAPI",
  platforms: [
    .iOS(.v12),
    .macOS(.v10_14),
    .tvOS(.v12),
    .watchOS(.v5),
  ],
  products: [
    .library(name: "GraphAPI", targets: ["GraphAPI"]),
    .library(name: "GraphAPITestMocks", targets: ["GraphAPITestMocks"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apollographql/apollo-ios.git", .exact("1.9.3")),
  ],
  targets: [
    .target(
      name: "GraphAPI",
      dependencies: [
        .product(name: "ApolloAPI", package: "apollo-ios"),
      ],
      path: "./Sources"
    ),
    .target(
      name: "GraphAPITestMocks",
      dependencies: [
        .product(name: "ApolloTestSupport", package: "apollo-ios"),
        .target(name: "GraphAPI"),
      ],
      path: "./GraphAPITestMocks"
    ),
    .testTarget(
      name: "GraphAPITests",
      dependencies: [
        .target(name: "GraphAPI")
      ],
      path: "./Tests/GraphAPITests"
    ),
  ]
)
