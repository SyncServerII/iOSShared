//
//  AlertyDisplayer.swift
//  
//
//  Created by Christopher G Prince on 2/14/21.
//

import Foundation
import SwiftUI

extension View {
    public func alertyDisplayer(show: Binding<AlertyContents?>, subscriber: AlertySubscriber) -> some View {
        self.alert(item: show) { (alertyContents) -> SwiftUI.Alert in
            alertyContents.alert
        }
        .onAppear() {
            subscriber.screenDisplayed = true
        }
        .onDisappear() {
            subscriber.screenDisplayed = false
            
            // I had been getting duplicate error messages. e.g., on sharing account creation by an invitation. This is to avoid this.
            subscriber.alertQueue.removeAll()
        }
    }
}

