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

public protocol MigrationRunner {
    func run(migrations: [Migration], contentChanges: [Migration]) throws
}

public protocol VersionedMigrationRunner: MigrationRunner {
    /// This must be persistently stored; i.e., across app launches it must retain its value. Should return 0 if not initialized. The optional value is provided only to deal with errors.
    static var schemaVersion: Int32? { get set }
}

extension VersionedMigrationRunner {
    // migrations: These are for column additions (and possibly deletions) only. See https://github.com/SyncServerII/Neebla/issues/26
    // contentChanges: These are for row content changes. They are applied after *all* `migrations` have been applied, starting with the original schemaVersion (before any `migrations` had been applied).
    public func run(migrations: [Migration], contentChanges: [Migration] = []) throws {
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

        for migration in contentChanges {
            if schemaVersion < migration.version {
                try migration.apply()
            }
            
            maxVersion = max(maxVersion, migration.version)
        }

        Self.schemaVersion = maxVersion
    }
}
