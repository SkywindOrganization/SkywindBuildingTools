//
//  CommandPlugin+formatCode.swift
//  Formatting
//
//  Copyright © 2022 Skywind. All rights reserved.
//

import Foundation
import PackagePlugin

extension CommandPlugin {

    func formatCode(in directory: PackagePlugin.Path, context: PluginToolProviding, arguments: [String]) throws {
        let tool = try context.tool(named: "formater")
        let toolURL: URL = .init(fileURLWithPath: tool.path.string)

        var processArguments = [directory.string]
        processArguments.append(contentsOf: arguments)

        let process = Process()
        process.executableURL = toolURL
        process.arguments = processArguments

        try process.run()
        process.waitUntilExit()

        guard process.terminationReason == .exit, process.terminationStatus == .zero else {
            let problem = "\(process.terminationReason):\(process.terminationStatus)"
            Diagnostics.error("格式化執行失敗: \(problem)")
            return
        }
        print("\(directory.string) 格式化完成")
    }
}
