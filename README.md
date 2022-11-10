# SkywindBuildingTools

Xcode 編譯時期工具

## 目前使用的工具

[SwiftFormat](https://github.com/nicklockwood/SwiftFormat.git) 程式碼自動格式化工具

## 安裝

## 修改

### 新增使用的插件

在 `isPerBuilding == true` 時將軟體包新增到 `Package.swift` 的 `dependencies` 中
如：

```swift
if isPerBuilding {
    dependencies.append(
        .package(
            url: "https://github.com/nicklockwood/SwiftFormat.git",
            .upToNextMajor(from: Version(0, 0, 0))
        )
    )
}
```

在 `isPerBuilding == true` 時將編譯工具的目標新增到 `Package.swift` 的 `targets` 中
如：

```swift
if isPerBuilding {
    targets.append(
        .executableTarget(
            name: "formater",
            dependencies: ["SwiftFormat"],
            path: "Sources/FormattingTool"
        )
    )
}
```

在 `isPerBuilding == true` 時將編譯工具的編譯結果定義新增到 `Package.swift` 的 `products` 中

如：

```swift
if isPerBuilding {
    products.append(
        .executable(
            name: "formater",
            targets: ["formater"]
        )
    )
}
```
