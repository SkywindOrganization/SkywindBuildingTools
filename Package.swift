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
        .plugin(name: "Formatting", targets: ["Formatting"]),
        .plugin(name: "Linting", targets: ["Linting"])
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "swiftformat",
            url: "https://github.com/nicklockwood/SwiftFormat/releases/download/0.50.3/swiftformat.artifactbundle.zip",
            checksum: "a3221d54c2ac00f5c0ce0a2ebc6906ee371d527814174a9c65983f3a3a395321"
        ),
        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.49.1/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "227258fdb2f920f8ce90d4f08d019e1b0db5a4ad2090afa012fd7c2c91716df3"
        ),
        .plugin(
            name: "Formatting",
            capability: .command(
                intent: .sourceCodeFormatting(),
                permissions: [
                    .writeToPackageDirectory(reason: "格式化時需要修改文件")
                ]
            ),
            dependencies: [
                .target(name: "swiftformat")
            ],
            path: "Sources/Formatting"
        ),
        .plugin(
            name: "Linting",
            capability: .buildTool(),
            dependencies: [
                .target(name: "SwiftLintBinary")
            ]
        )
    ]
)
