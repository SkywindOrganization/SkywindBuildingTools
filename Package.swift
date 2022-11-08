// swift-tools-version: 5.7
//
// SkywindBuildingTools
//
// Copyright © 2022 Skywind. All rights reserved.
//

import PackageDescription

import class Foundation.ProcessInfo

let isPerBuild: Bool = false // ProcessInfo.processInfo.environment["PER_BUILDING"] != nil

/// 當環境變數有預建構旗標連結依賴庫進行編譯
var dependencies: [Package.Dependency] = []
    + (isPerBuild
        ? [
            .package(
                url: "https://github.com/nicklockwood/SwiftFormat.git",
                .upToNextMajor(from: Version(0, 0, 0))
            )
        ]
        : [])

var formattingDependencies: [Target.Dependency] = []
    + (isPerBuild
        ? [
            .target(name: "formater")
        ]
        : [
            .target(name: "PerBuildFormater")
        ])

var targets: [Target] = [
] + (isPerBuild
    ? [
        .executableTarget(
            name: "formater",
            dependencies: ["SwiftFormat"],
            path: "Sources/FormatingTool"
        )
    ]
    : [
        .target(
            name: "PerBuildFormater",
            path: "Per-Build",
            resources: [.copy("formater")]
        ),
        .plugin(
            name: "Formatting",
            capability: .command(
                intent: .sourceCodeFormatting(),
                permissions: [
                    .writeToPackageDirectory(reason: "格式化時需要修改文件")
                ]
            ),
            dependencies: formattingDependencies,
            path: "Sources/Formating"
        )
    ])

let products: [Product] = [
] + (isPerBuild
    ? [
        .executable(name: "formater", targets: ["formater"])
    ]
    : [
        .executable(name: "PerBuildFormater", targets: ["PerBuildFormater"]),
        .plugin(name: "Formatting", targets: ["Formatting"])
    ])

let package = Package(
    name: "SkywindBuildingTools",
    platforms: [.macOS(.v12)],
    products: products,
    dependencies: dependencies,
    targets: targets
)
