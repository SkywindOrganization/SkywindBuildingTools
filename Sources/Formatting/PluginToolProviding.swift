//
//  PluginToolProviding.swift
//  Formatting
//
//  Copyright © 2022 Skywind. All rights reserved.
//

import Foundation
import PackagePlugin

/// 用於使不同目標取得插件執行路徑
protocol PluginToolProviding {

    func tool(named name: String) throws -> PackagePlugin.PluginContext.Tool
}

// MARK: - PluginContext + PluginToolProviding

extension PluginContext: PluginToolProviding {}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

// MARK: - XcodePluginContext + PluginToolProviding

extension XcodePluginContext: PluginToolProviding {}
#endif
