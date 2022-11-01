// swift-tools-version: 5.7
//
// SkywindBuildingTools
//
// Copyright © 2022 Skywind. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "SkywindBuildingTools",
    platforms: [.macOS(.v12)],
    products: [
        .plugin(name: "Formatting", targets: ["Formatting"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/nicklockwood/SwiftFormat.git",
            .upToNextMajor(from: Version(0, 0, 0))
        )
    ],
    targets: [
        .plugin(
            name: "Formatting",
            capability: .command(
                intent: .sourceCodeFormatting(),
                permissions: [
                    .writeToPackageDirectory(reason: "格式化時需要修改文件")
                ]
            ),
            dependencies: [
                .product(name: "swiftformat", package: "SwiftFormat")
            ],
            path: "Sources/Formatting"
        )
    ]
)
