// swift-tools-version: 5.7
//
// SkywindBuildingTools
//
// Copyright © 2022 Skywind. All rights reserved.
//

import PackageDescription

#if true
// 只有在除錯模式引用原程式碼並編譯
let dependencies: [Package.Dependency] = [
    .package(
        url: "https://github.com/nicklockwood/SwiftFormat.git",
        .upToNextMajor(from: Version(0, 0, 0))
    )
]
var targets: [Target] = [
    .executableTarget(name: "formater", dependencies: ["SwiftFormat"], path: "Sources/FormatingTool")
]
let formattingDependencies: [Target.Dependency] = [
    .target(name: "formater")
]
#else
// 釋出模式使用預編譯的可執行檔
let dependencies: [Package.Dependency] = []
var targets: [Target] = []
let formattingDependencies: [Target.Dependency] = []
#endif

targets.append(
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
)

let package = Package(
    name: "SkywindBuildingTools",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "formater", targets: ["formater"]),
        .plugin(name: "Formatting", targets: ["Formatting"])
    ],
    dependencies: dependencies,
    targets: targets
)
