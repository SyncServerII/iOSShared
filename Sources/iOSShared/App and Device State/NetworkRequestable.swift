//
//  NetworkRequestable.swift
//  
//
//  Created by Christopher G Prince on 3/17/21.
//

import Foundation

public struct NetworkRequestableOptions: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
  
    public static let network = NetworkRequestableOptions(rawValue: 1 << 0)
    public static let app = NetworkRequestableOptions(rawValue: 1 << 1)
    
    public static let all:NetworkRequestableOptions = [.network, .app]
}

public protocol NetworkRequestable {
    // Is the app and the network in a state where network requests can be made?
    var canMakeNetworkRequests: Bool { get }
    
    // A more fine grained check than the Bool property.
    func canMakeNetworkRequests(options:NetworkRequestableOptions) -> Bool
}
