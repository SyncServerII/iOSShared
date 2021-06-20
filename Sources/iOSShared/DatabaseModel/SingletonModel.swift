//
//  SingletonModel.swift
//  
//
//  Created by Christopher G Prince on 1/17/21.
//

import Foundation
import SQLite

public protocol SingletonModel: DatabaseModel {
    // This will be called once from `setupSingleton` during the lifetime of the app, to create the singleton row and initialize it. Must not insert it.
    static func createSingletonRow(db: Connection) throws -> M
}

public extension SingletonModel {
    // Set up the singleton if not present. Creates the table if not yet created.
    static func setupSingleton(db: Connection) throws {
        try Self.createTable(db: db)
        let result = try Self.fetch(db: db)
        switch result.count {
        case 1:
            return
            
        case 0:
            let singleton = try createSingletonRow(db: db)
            try singleton.insert()
            
        default:
            throw DatabaseModelError.moreThanOneRowInResult("setupSingleton")
        }
    }
    
    static func getSingleton(db: Connection) throws -> M {
        let singleton = try Self.fetch(db: db)
        
        guard singleton.count == 1 else {
            throw DatabaseModelError.notExactlyOneRow
        }
        
        return singleton[0]
    }
}
