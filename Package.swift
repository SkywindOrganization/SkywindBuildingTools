// swift-tools-version: 5.7
//
// SkywindBuildingTools
//
// Copyright © 2022 Skywind. All rights reserved.
//

import PackageDescription

import class Foundation.ProcessInfo

/// 檢查是否在預編譯模式
let isPerBuilding: Bool = true // ProcessInfo.processInfo.environment["PER_BUILDING"] != nil

// MARK: - 外部介面

/// 預編譯中模式外部介面為可執行檔，一般使用模式則為插件介面
var products: [Product] = []

if isPerBuilding {
    products.append(
        .executable(
            name: "formater",
            targets: ["formater"]
        )
    )
    products.append(
        .executable(
            name: "linter",
            targets: ["linter"]
        )
    )
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
            branch: "0.50.0-rc.4"
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
    targets.append(
        .executableTarget(
            name: "linter",
            dependencies: [.product(name: "SwiftLintFramework", package: "SwiftLint")],
            path: "Sources/LintingTool"
        )
    )
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
            name: "linter",
            path: "Per-Build/linter.artifactbundle"
        ),
        .plugin(
            name: "Linting",
            capability: .buildTool(),
            dependencies: [
                .target(name: "linter")
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
