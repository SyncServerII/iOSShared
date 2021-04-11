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
    var alertQueue: [AlertyContents] = [] {
        didSet {
            // Execute all of the below on the main queue to avoid race conditions with setting show to true.
            DispatchQueue.main.async {
                // If we don't constrain this by whether or not the screen is displayed, when we navigate to other screens, we get the same error, once per screen-- because each screen model has an `errorSubscription`. I don't know if having these models remain allocated is standard behavior for SwiftUI, but currently it is the case.
                let shouldShow = self.alertQueue.count > 0 && self.screenDisplayed && !self.show
                if shouldShow {
                    self.show = true
                }
            }
        }
    }
    
    let debugMessage: String?
    public var screenDisplayed = false
    @Published public var show = false {
        didSet {
            // Doing a dispatch here as there seems to be need to be a delay to actually display the next message if there is one. And to avoid a race condition in setting `show`.
            DispatchQueue.main.async {
                let shouldShowNext = self.alertQueue.count > 0 && self.screenDisplayed && !self.show
                logger.debug("shouldShowNext: \(shouldShowNext), alertQueue.count: \(self.alertQueue.count), screenDisplayed: \(self.screenDisplayed), show: \(self.show)")
                if shouldShowNext {
                    self.show = true
                }
            }
        }
    }

    public init(debugMessage: String? = nil, publisher: AlertyPublisher) {
        self.debugMessage = debugMessage
        
        subscription = publisher.alerty.sink(receiveValue: { [weak self] contents in
            guard let self = self else { return }
            if let contents = contents, self.screenDisplayed {
                self.alertQueue.append(contents)
            }
        })
    }
    
    func getAlert() -> SwiftUI.Alert {
        if alertQueue.count > 0 {
            let head = alertQueue[0]
            alertQueue.removeFirst()
            return head.alert
        }
        else {
            logger.error("Unknown alert")
            return SwiftUI.Alert(title: Text("Unknown Alert"))
        }
    }
}
