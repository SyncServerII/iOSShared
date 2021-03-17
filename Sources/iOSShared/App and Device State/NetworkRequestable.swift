//
//  NetworkRequestable.swift
//  
//
//  Created by Christopher G Prince on 3/17/21.
//

import Foundation

public protocol NetworkRequestable {
    // Is the app in a state where it can make network requests?
    var canMakeNetworkRequests: Bool { get }
}
