// swift-tools-version: 5.7
//
// SkywindBuildingTools
//
// Copyright © 2022 Skywind. All rights reserved.
//

import PackageDescription

import class Foundation.ProcessInfo

/// 檢查是否在預編譯模式
let isPerBuilding: Bool = false // ProcessInfo.processInfo.environment["PER_BUILDING"] != nil

// MARK: - 外部介面

/// 預編譯中模式外部介面為可執行檔，一般使用模式則為插件介面
var products: [Product] = []

if isPerBuilding {
    products.append(contentsOf: [
        .executable(
            name: "formater",
            targets: ["formater"]
        )
    ])
} else {
    products.append(contentsOf: [
        .plugin(
            name: "Formatting",
            targets: ["Formatting"]
        ),
        .plugin(
            name: "Linting",
            targets: ["Linting"]
        )
    ])
}

// MARK: - 外部依賴

/// 當為預編譯中模式時加入所需要的外部依賴，一般使用模式時則沒有外部依賴，只使用預編譯完成的可執行組件
var dependencies: [Package.Dependency] = []

if isPerBuilding {
    dependencies.append(
        .package(
            url: "https://github.com/nicklockwood/SwiftFormat.git",
            .upToNextMajor(from: Version(0, 0, 0))
        )
    )
    dependencies.append(
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            .upToNextMajor(from: Version(0, 0, 0))
        )
    )
}

// MARK: - 編譯目標

/// 在預編譯中模式時要編譯可執行目標，而一般模式則是使用已編譯二進制目標與插件結構
var targets: [Target] = []

if isPerBuilding {
    targets.append(contentsOf: [
        .executableTarget(
            name: "formater",
            dependencies: ["SwiftFormat"],
            path: "Sources/FormattingTool"
        )
    ])
} else {
    targets.append(contentsOf: [
        .binaryTarget(
            name: "formater",
            path: "Per-Build/formater.artifactbundle"
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
                .target(name: "formater")
            ],
            path: "Sources/Formatting"
        )
    ])
    targets.append(contentsOf: [
        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.49.1/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "227258fdb2f920f8ce90d4f08d019e1b0db5a4ad2090afa012fd7c2c91716df3"
        ),
        .plugin(
            name: "Linting",
            capability: .buildTool(),
            dependencies: [
                .target(name: "SwiftLintBinary")
            ],
            path: "Sources/Linting"
        )
    ])
}

// MARK: - 軟體包定義

let package = Package(
    name: "SkywindBuildingTools",
    platforms: [.macOS(.v12)],
    products: products,
    dependencies: dependencies,
    targets: targets,
    swiftLanguageVersions: [.v5]
)
