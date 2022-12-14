// swift-tools-version: 5.7
//
// SkywindBuildingTools
//
// Copyright © 2022 Skywind. All rights reserved.
//

import PackageDescription

import class Foundation.ProcessInfo

/// 檢查是否在預編譯模式
let isPerBuilding: Bool = ProcessInfo.processInfo.environment["PER_BUILDING"] != nil

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
} else {
    products.append(contentsOf: [
        .plugin(
            name: "Formatting",
            targets: ["Formatting"]
        ),
        .plugin(
            name: "Linting",
            targets: ["SwiftLintBinary"]
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
            exact: Version(0, 50, 6)
        )
    )
}

// MARK: - 編譯目標

/// 在預編譯中模式時要編譯可執行目標，而一般模式則是使用已編譯二進制目標與插件結構
var targets: [Target] = []

if isPerBuilding {
    targets.append(
        .executableTarget(
            name: "formater",
            dependencies: [
                .product(name: "swiftformat", package: "SwiftFormat")
            ],
            path: "Sources/FormattingTool"
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
    targets.append(
        .binaryTarget(
            name: "SwiftLintBinary",
            url: """
                https://github.com/realm/SwiftLint/releases/download/0.50.3/SwiftLintBinary-macos.artifactbundle.zip
                """,
            checksum: "abe7c0bb505d26c232b565c3b1b4a01a8d1a38d86846e788c4d02f0b1042a904"
        )
    )
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
