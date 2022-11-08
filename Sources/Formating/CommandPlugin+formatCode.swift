//
//  CommandPlugin+formatCode.swift
//  Formatting
//
//  Copyright © 2022 Skywind. All rights reserved.
//

import Foundation
import PackagePlugin

#if canImport(PerBuildFormater)
import PerBuildFormater
#else
 let execPath: URL? = nil
#endif

extension CommandPlugin {

    func formatCode(in directory: PackagePlugin.Path, context: PluginToolProviding, arguments: [String]) throws {
        var toolURL: URL
        if let fileURL: URL = execPath {
            toolURL = fileURL
            print("Test")
//            let test = FileManager.default.currentDirectoryPath
//                .appending("/SkywindBuildingTools_formater.bundle/Contents/Resources/formater")
//            let testURL = URL(fileURLWithPath: test)
        } else {
            let tool = try context.tool(named: "swiftformat")
            toolURL = URL(fileURLWithPath: tool.path.string)
        }

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
