//
//  Bundle+Extras.swift
//  
//
//  Created by Christopher G Prince on 1/9/21.
//

import Foundation

public extension Bundle {
    // See https://stackoverflow.com/questions/25048026
    static var isAppExtension: Bool {
        let bundleUrl = Bundle.main.bundleURL
        let bundlePathExtension = bundleUrl.pathExtension
        return bundlePathExtension == "appex"
    }
}
