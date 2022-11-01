//
//  FormattingPlugin.swift
//  Formatting
//
//  Copyright © 2022 Skywind. All rights reserved.
//

import Foundation
import PackagePlugin

@main
struct FormattingPlugin: CommandPlugin {

    /// 執行者是 Swift Package  Manager 時執行格式化時的進入點
    func performCommand(context: PluginContext, arguments: [String]) throws {
        if arguments.contains("--verbose") {
            print("""
                執行時額外參數： \(arguments.description)
                格式化軟體包名稱： \(context.package.displayName).
                所有執行目標： \(context.package.targets.description)
            """)
        }

        var targetsToProcess: [Target] = context.package.targets

        var argExtractor = ArgumentExtractor(arguments)

        let selectedTargets = argExtractor.extractOption(named: "target")

        if selectedTargets.isEmpty == false {
            targetsToProcess = context.package.targets.filter { selectedTargets.contains($0.name) }.map { $0 }
        }

        for target in targetsToProcess {
            guard let target = target as? SourceModuleTarget else { continue }

            try formatCode(
                in: target.directory,
                context: context,
                arguments: argExtractor.remainingArguments
            )
        }
    }
}
