//
//  FormattingPlugin+XcodeCommandPlugin.swift
//  Formatting
//
//  Copyright © 2022 Skywind. All rights reserved.
//

import Foundation
import PackagePlugin

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension FormattingPlugin: XcodeCommandPlugin {

    /// 當執行者是 Xcode  時執行格式化時的進入點
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        if arguments.contains("--verbose") {
            print("""
                執行時額外參數： \(arguments.description)
                格式化專案名稱： \(context.xcodeProject.displayName).
                所有執行目標： \(context.xcodeProject.targets.description)\n
                執行目標資料夾: \(context.xcodeProject.directory.description)
            """)
        }

        var argExtractor = ArgumentExtractor(arguments)
        _ = argExtractor.extractOption(named: "target")

        try formatCode(
            in: context.xcodeProject.directory,
            context: context,
            arguments: argExtractor.remainingArguments
        )
    }
}
#endif
