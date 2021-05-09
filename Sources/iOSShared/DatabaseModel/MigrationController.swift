//
//  MigrationController.swift
//  
//
//  Created by Christopher G Prince on 5/8/21.
//

import Foundation
import SQLite

// Apply this migration if the current schema version is less than the given version.
public protocol Migration: AnyObject {
    var version: Int32 { get }
    func apply() throws
}

public class MigrationObject: Migration {
    public let version: Int32
    let applyBlock: () throws ->()
    
    public init(version: Int32, apply: @escaping () throws -> ()) {
        self.version = version
        self.applyBlock = apply
    }
    
    public func apply() throws {
        try self.applyBlock()
    }
}

enum MigrationError: Error {
    case noSchemaVersion
}
    
public protocol MigrationController: AnyObject {
    var db: Connection { get }
    
    /// This must be persistently stored; i.e., across app launches it must retain its value. Should return 0 if not initialized. The optional value is provided only to deal with errors.
    static var schemaVersion: Int32? { get set }
}

extension MigrationController {
    public func run(migrations: [Migration]) throws {
        guard let schemaVersion = Self.schemaVersion else {
            logger.error("No schema version")
            throw MigrationError.noSchemaVersion
        }
        
        var maxVersion: Int32 = 0
        
        for migration in migrations {
            if schemaVersion < migration.version {
                try migration.apply()
            }
            
            maxVersion = max(maxVersion, migration.version)
        }
        
        Self.schemaVersion = maxVersion
    }
}
