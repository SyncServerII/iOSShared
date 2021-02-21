//
//  Errors.swift
//  
//
//  Created by Christopher G Prince on 2/20/21.
//

import Foundation

public protocol Errors: Error {
    var networkIsNotReachable: Bool {get}
}
