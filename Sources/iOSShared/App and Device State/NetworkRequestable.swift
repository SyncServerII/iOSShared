//
//  NetworkRequestable.swift
//  
//
//  Created by Christopher G Prince on 3/17/21.
//

import Foundation

public protocol NetworkRequestable {
    // Is the app and the network in a state where network requests can be made?
    var canMakeNetworkRequests: Bool { get }
}
