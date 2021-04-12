//
//  AlertyContents.swift
//  
//
//  Created by Christopher G Prince on 2/14/21.
//

import Foundation
import SwiftUI
import Combine

public struct AlertyContents: CustomDebugStringConvertible, Identifiable {
    public let id = UUID()
    public let alert: SwiftUI.Alert
    
    public var debugDescription: String {
        return "\(alert)"
    }
    
    public init(_ alert: SwiftUI.Alert) {
        self.alert = alert
    }
}

/*
A centralized SwiftUI alert mechanism that can be utilized as a @StateObject.
To listen to one centralized published event and show alerts on that basis.
*/

public class AlertyPublisher {
    // Assign to this to send alerts to the user. Subscribe to this to show alerts to the user.
    // @Published public var alerty: AlertyContents?
    
    // `PassthroughSubject`: "If you subscribe to it you will get all the events that will happen after you subscribed." (https://medium.com/ios-os-x-development/learn-master-%EF%B8%8F-the-basics-of-combine-in-5-minutes-639421268219)
    public let alerty = PassthroughSubject<AlertyContents?, Never>()
    
    public init() {
    }
}

public protocol AlertyDelegate: AnyObject {
    func showAlert(_ alert: SwiftUI.Alert?)
}
