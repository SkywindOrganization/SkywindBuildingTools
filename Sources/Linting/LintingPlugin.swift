//
//  LintingPlugin.swift
//  Linting
//
//  Copyright © 2022 Skywind. All rights reserved.
//

import Foundation
import PackagePlugin

@main
struct SwiftLintPlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PackagePlugin.PluginContext,
        target _: PackagePlugin.Target
    ) async throws -> [PackagePlugin.Command] {
        [
            .buildCommand(
                displayName: "SwiftLint",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "lint",
                    "--cache-path", "\(context.pluginWorkDirectory)"
                ]
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLintPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(
        context: XcodePluginContext,
        target _: XcodeTarget
    ) throws -> [Command] {
        [
            .buildCommand(
                displayName: "SwiftLint",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "lint",
                    "--cache-path", "\(context.pluginWorkDirectory)"
                ]
            )
        ]
    }
}
#endif
