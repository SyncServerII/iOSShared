//
//  Binding+Extras.swift
//  
//
//  Created by Christopher G Prince on 9/12/21.
//

import Foundation
import SwiftUI

// See https://stackoverflow.com/questions/57021722/swiftui-optional-textfield
public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
