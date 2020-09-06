import Logging

// I'd really like to centralize this Logger instantiation. See https://github.com/apple/swift-log/issues/155
public private(set) var logger = Logger(label: "com.SpasticMuffin.Neebla")

public func set(logLevel: Logging.Logger.Level) {
    logger.logLevel = logLevel
}
