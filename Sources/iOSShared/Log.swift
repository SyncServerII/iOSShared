import Logging
import FileLogging
import Foundation
import XCGLogger

// I'd really like to centralize this Logger instantiation. See https://github.com/apple/swift-log/issues/155
public private(set) var logger = Logger(label: "")

public let sharedLogging = SharedLogging()

public class SharedLogging {
    var fileDestination:AutoRotatingFileDestination!
    var logFileURL: URL!
    
    public var archivedFileURLs: [URL] {
        return fileDestination.archivedFileURLs() + [logFileURL]
    }
    
    public func setup(logFileURL: URL, logLevel: Logging.Logger.Level = .trace, logLabel: String = "") throws {
        self.logFileURL = logFileURL
        logger = createLogger(logFileURL: logFileURL, label: logLabel)
        logger.logLevel = logLevel
    }
    
    func createLogger(logFileURL: URL, label: String) -> Logger {
        let xcgLogger = makeFileXCGLogger()

        LoggingSystem.bootstrap { label in
            let handlers:[LogHandler] = [
                XCGLoggerHandler(label: label, logger: xcgLogger),
                StreamLogHandler.standardOutput(label: label)
            ]

            return MultiplexLogHandler(handlers)
        }
        
        return Logger(label: label)
    }
    
    func makeFileXCGLogger(level: XCGLogger.Level = .verbose) -> XCGLogger {
        // Create a logger object with no destinations
        let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)
        
        // Create a file log destination
        fileDestination = AutoRotatingFileDestination(writeToFile: logFileURL.path, identifier: "advancedLogger.fileDestination", shouldAppend: true)
        
        // Optionally set some configuration options
        fileDestination.outputLevel = level
        fileDestination.showLogIdentifier = false
        fileDestination.showFunctionName = true
        fileDestination.showThreadName = true
        fileDestination.showLevel = true
        fileDestination.showFileName = true
        fileDestination.showLineNumber = true
        fileDestination.showDate = true
        
        // Trying to get max total log size that could be sent to developer to be around 1MByte; this comprises one current log file and two archived log files.
        fileDestination.targetMaxFileSize = (1024 * 1024) / 3 // 1/3 MByte
        
        // These are archived log files.
        fileDestination.targetMaxLogFiles = 2

        // Process this destination in the background
        fileDestination.logQueue = XCGLogger.logQueue

        // Add the destination to the logger
        log.add(destination: fileDestination)

        // Add basic app info, version info etc, to the start of the logs
        log.logAppDetails()
        return log
    }
}
