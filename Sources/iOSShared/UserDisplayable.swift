//
//  UserDisplayable.swift
//  iOSShared
//
//  Created by Christopher G Prince on 3/14/21.
//

import Foundation

public protocol UserDisplayable: Error {
    var userDisplayableMessage: (title: String, message: String)? { get }
}
