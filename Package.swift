// swift-tools-version: 5.7
//
// SkywindBuildingTools
//
// Copyright © 2022 Skywind. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "SkywindBuildingTools",
    products: [
        .library(name: "SkywindBuildingTools", targets: ["SkywindBuildingTools"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SkywindBuildingTools",
            dependencies: []
        )
    ]
)
