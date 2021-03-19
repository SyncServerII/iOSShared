//
//  BackgroundTask.swift
//  
//
//  Created by Christopher G Prince on 3/18/21.
//

import Foundation
import UIKit

public protocol BackgroundAsssertable {
    // Executing the `task` should take relatively little time, but it needs to be protected in case the app starts running in the background while it is executing.
    // The `task` closure parameter is passed as @escaping, but `run` is synchronous.
    // `expiry` is called only if the task takes longer than expected and the execution time is about to expire.
    func run<T>(task: @escaping ()->(T?), expiry: (()->())?) -> T?
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
    
    public func run<T>(task: @escaping ()->(T?), expiry: (()->())? = nil) -> T? {
        let identifier = start()
        let result = task()
        end(identifier: identifier)
        return result
    }
}

public class ExtensionBackgroundTask: BackgroundAsssertable {
    var identifiers = Set<UUID>()
    
    public init() {}
    
    public func run<T>(task: @escaping ()->(T?), expiry: (()->())? = nil) -> T? {
        let identifier = UUID()
        
        // This method queues block for asynchronous execution on a concurrent queue. But I want to wait for it to end, and do `run` synchronously.
        let group = DispatchGroup()
        group.enter()
        
        var result: T?
        
        ProcessInfo.processInfo.performExpiringActivity(withReason: identifier.uuidString) { [weak self] expired in
            guard let self = self else { return }
            
            // Because the closure passed to `performExpiringActivity` can be called more than once.
            if self.identifiers.contains(identifier) {
                expiry?()
                return
            }
            
            self.identifiers.insert(identifier)
            
            result = task()
            
            self.identifiers.remove(identifier)
            group.leave()
        }
        
        group.wait()
        
        return result
    }
}



