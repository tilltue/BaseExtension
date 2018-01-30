//
//  BaseLogger.swift
//  BaseExtension
//
//  Created by wade.hawk on 2017. 10. 9..
//

import XCGLogger

public let log = XCGLogger.default

public struct BaseLogger {
    public static func setupLogger(level: XCGLogger.Level? = nil) {
        #if DEBUG
            log.setup(level: level ?? .verbose, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true)
        #else
            log.setup(level: level ?? .severe, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true)
            if let consoleLog = log.destination(withIdentifier: XCGLogger.Constants.baseConsoleDestinationIdentifier) as? ConsoleDestination {
                consoleLog.logQueue = XCGLogger.logQueue
            }
        #endif
    }
}
