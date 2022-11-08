//
//  main.swift
//  FormatingTool
//
//  Copyright © 2022 Skywind. All rights reserved.
//

import Foundation

#if os(macOS)
import Darwin.POSIX
#elseif os(Windows)
import ucrt
#else
import Glibc
#endif

#if SWIFT_PACKAGE
import SwiftFormat
#endif

extension String {
    var inDefault: String { "\u{001B}[39m\(self)" }
    var inRed: String { "\u{001B}[31m\(self)\u{001B}[0m" }
    var inGreen: String { "\u{001B}[32m\(self)\u{001B}[0m" }
    var inYellow: String { "\u{001B}[33m\(self)\u{001B}[0m" }
}

// MARK: - FileHandle + TextOutputStream

extension FileHandle: TextOutputStream {
    public func write(_ string: String) {
        write(Data(string.utf8))
    }
}

private var stderr = FileHandle.standardError

private let stderrIsTTY = isatty(STDERR_FILENO) != 0

private let printQueue = DispatchQueue(label: "swiftformat.print")

CLI.print = { message, type in
    printQueue.sync {
        switch type {
        case .info:
            print(message, to: &stderr)
        case .success:
            print(stderrIsTTY ? message.inGreen : message, to: &stderr)
        case .error:
            print(stderrIsTTY ? message.inRed : message, to: &stderr)
        case .warning:
            print(stderrIsTTY ? message.inYellow : message, to: &stderr)
        case .content:
            print(message)
        case .raw:
            print(message, terminator: "")
        }
    }
}

exit(CLI.run(in: FileManager.default.currentDirectoryPath).rawValue)
