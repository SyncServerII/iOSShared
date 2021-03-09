//
//  AlertySubscriber.swift
//  
//
//  Created by Christopher G Prince on 2/14/21.
//

import Foundation
import SwiftUI
import Combine

public class AlertySubscriber: ObservableObject {
    var subscription:AnyCancellable!
    var alert: AlertyContents? {
        didSet {
            // If we don't constrain this by whether or not the screen is displayed, when we navigate to other screens, we get the same error, once per screen-- because each screen model has an `errorSubscription`. I don't know if having these models remain allocated is standard behavior for SwiftUI, but currently it is the case.
            let shouldShow = alert != nil && screenDisplayed
            logger.debug("didSet userAlert: shouldShow: \(shouldShow); \(String(describing: debugMessage)): userAlert: \(String(describing: self.alert)): screenDisplayed: \(screenDisplayed)")
            if self.show != shouldShow {
                DispatchQueue.main.async {
                    self.show = shouldShow
                }
            }
        }
    }
    
    let debugMessage: String?
    public var screenDisplayed = false
    @Published public var show = false

    public init(debugMessage: String? = nil, publisher: AlertyPublisher) {
        self.debugMessage = debugMessage
        
        subscription = publisher.alerty.sink(receiveValue: { [weak self] contents in
            guard let self = self else { return }
            logger.debug("debugMessage: \(String(describing: debugMessage)); sink: \(String(describing: contents))")
            self.alert = contents
        })
    }
    
    func getAlert() -> SwiftUI.Alert {
        if let alert = alert {
            return alert.alert
        }
        else {
            logger.error("Unknown alert")
            return SwiftUI.Alert(title: Text("Unknown Alert"))
        }
    }
}
