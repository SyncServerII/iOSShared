import Logging

// I'd really like to centralize this Logger instantiation. See https://github.com/apple/swift-log/issues/155
public private(set) var logger = Logger(label: "")

public func set(logLevel: Logging.Logger.Level, logLabel: String = "") {
    logger = Logger(label: logLabel)
    logger.logLevel = logLevel
}
