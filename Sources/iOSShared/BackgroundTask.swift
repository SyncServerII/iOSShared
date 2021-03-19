//
//  BackgroundTask.swift
//  
//
//  Created by Christopher G Prince on 3/18/21.
//

import Foundation
import UIKit

// See also https://github.com/SyncServerII/Neebla/issues/7

public protocol BackgroundAsssertable {
    // `task` runs synchronously, and needs to be protected in case the app starts running in the background while executing.
    // The `task` closure parameter is passed as @escaping, but `syncRun` is synchronous.
    // `expiry` is called only if the task takes longer than expected and the execution time is about to expire.
    func syncRun<T>(task: @escaping () throws ->(T?), expiry: (()->())?) throws -> T?

    // Similar, but `task` runs asynhronously.
    // The async `task` must call the `completion` when it's done.
    func asyncRun(task: @escaping (_ completion: @escaping ()->())->(), expiry: (()->())?)
}

public class MainAppBackgroundTask: BackgroundAsssertable {
    private let application = UIApplication.shared
    
    public init() {}
    
    func start(expiry: (()->())? = nil) -> UIBackgroundTaskIdentifier {
        var identifier:UIBackgroundTaskIdentifier!
        identifier = application.beginBackgroundTask { [weak self] in
            expiry?()
            self?.end(identifier: identifier)
        }
        return identifier
    }
    
    func end(identifier: UIBackgroundTaskIdentifier) {
        application.endBackgroundTask(identifier)
    }
    
    public func syncRun<T>(task: @escaping () throws ->(T?), expiry: (()->())?) throws -> T? {
        let identifier = start() {
            expiry?()
        }
        let result = try task()
        end(identifier: identifier)
        return result
    }
    
    public func asyncRun(task: @escaping (_ completion: @escaping ()->())->(), expiry: (()->())?) {
        let identifier = start() {
            expiry?()
        }
        task() { [weak self] in
            self?.end(identifier: identifier)
        }
    }
}

public class ExtensionBackgroundTask: BackgroundAsssertable {
    var identifiers = Set<UUID>()
    
    public init() {}
    
    public func syncRun<T>(task: @escaping () throws ->(T?), expiry: (()->())?) throws -> T? {
        let identifier = UUID()
        
        // This method queues block for asynchronous execution on a concurrent queue. But I want to wait for it to end, and do `run` synchronously.
        let group = DispatchGroup()
        group.enter()
        
        var result: T?
        var throwError: Error?
        
        ProcessInfo.processInfo.performExpiringActivity(withReason: identifier.uuidString) { [weak self] expired in
            guard let self = self else { return }
            
            // Because the closure passed to `performExpiringActivity` can be called more than once.
            if self.identifiers.contains(identifier) {
                expiry?()
                return
            }
            
            self.identifiers.insert(identifier)
            
            do {
                result = try task()
            } catch let error {
                throwError = error
            }
            
            self.identifiers.remove(identifier)
            group.leave()
        }
        
        group.wait()
        
        if let throwError = throwError {
            throw throwError
        }
        
        return result
    }
    
    public func asyncRun(task: @escaping (_ completion: @escaping ()->())->(), expiry: (()->())?) {
        let identifier = UUID()
        
        // This method queues block for asynchronous execution on a concurrent queue.
        
        ProcessInfo.processInfo.performExpiringActivity(withReason: identifier.uuidString) { [weak self] expired in
            guard let self = self else { return }
            
            // Because the closure passed to `performExpiringActivity` can be called more than once.
            if self.identifiers.contains(identifier) {
                expiry?()
                return
            }
            
            self.identifiers.insert(identifier)
            
            task() {
                self.identifiers.remove(identifier)
            }
        }
    }
}



